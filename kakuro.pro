
% ================== CORRECTITUD DE UN TABLERO ================== %
blank(X, Y) :- X >= 0, Y >= 0.

% blanksRow(B, X, Y) verifica que B es una lista de casillas blancas
% que estan en fila e inician en el punto (X, Y).
blanksRow([], _, _).
blanksRow([Blank|BlankList], Xvar, Yconst) :- 
    Blank = blank(Xvar, Yconst),
    blank(Xvar, Yconst), 
    SigX is Xvar+1, 
    blanksRow(BlankList, SigX, Yconst).

% blanksCol(B, X, Y) verifica que B es una lista de casillas blancas
% que estan en columna e inician en el punto (X, Y).
blanksCol([], _, _).
blanksCol([Blank|BlankList], Xconst, Yvar) :- 
    Blank = blank(Xconst, Yvar),
    blank(Xconst, Yvar), 
    SigY is Yvar+1, 
    blanksCol(BlankList, Xconst, SigY).

% Para que clue(X, Y, Sum, B) sea cierto, Sum tiene que ser mayor que 0 y
% B tiene que ser una fila o columna de blancos adyacentes al punto (X, Y)
clue(X, Y, Sum, [Blank|BlankList]) :-
  Sum > 0,
  SigX is X+1,
  Blank = blank(SigX, Y),
  blanksRow([Blank|BlankList], SigX, Y).
clue(X, Y, Sum, [Blank|BlankList]) :-
  Sum > 0,
  SigY is Y+1,
  Blank = blank(X, SigY),
  blanksCol([Blank|BlankList], X, SigY).

% Verifica que una lista solo contiene clues validos.
verifyClues([]).
verifyClues([clue(X, Y, S, L)|ClueList]) :-
  clue(X, Y, S, L),
  verifyClues(ClueList).


% VERIFICACION DE QUE UNA CASILLA CONTIENE A LO SUMO 2 CLUES.

% maxClues(C, L, N) verifica que en L hay a lo sumo N clues con la misma
% casilla que el clue C.
maxClues(_, [], N) :- N >= 0.
maxClues(Clue, [Clue|ClueList], N) :-
  N > 0,
  M is N-1,
  maxClues(Clue, ClueList, M).
maxClues(Clue, [OtherClue|ClueList], N) :-
  N >= 0,
  Clue \= OtherClue,
  maxClues(Clue, ClueList, N).

% Verifica que en una lista de clues, una casilla tiene a lo sumo 2 clues.
atMost2Clues([]).
atMost2Clues([Clue|ClueList]) :- 
  maxClues(Clue, ClueList, 1),
  atMost2Clues(ClueList).

% notInRow(X, Y, L) verifica que el punto (X, Y) no esta en
% ninguna casilla blanca en fila de L.
notInRow(X, Y, [FirstBlank|BlankList]) :-
  FirstBlank = blank(Fx, Fy),
  (
    % No esta en la misma columna
    Y \= Fy ; 
    (
      % O no se encuentra entre el primer y el ultimo blank.
      last([FirstBlank|BlankList], LastBlank),
      LastBlank = blank(Lx, _),
      (X < Fx ; Lx < X)
    )
  ).

% notInCol(X, Y, L) verifica que el punto (X, Y) no esta en
% ninguna casilla blanca en columna de L.
notInCol(X, Y, [FirstBlank|BlankList]) :-
  FirstBlank = blank(Fx, Fy),
  (
    % No esta en la misma fila
    X \= Fx ; 
    (
      % O no se encuentra entre el primer y el ultimo blank.
      last([FirstBlank|BlankList], LastBlank),
      LastBlank = blank(_, Ly),
      (Y < Fy ; Ly < Y)
    )
  ).

% notInClue(X, Y, C) verifica que el punto X, Y no esta en ningun blank
% del clue C
notInClue(X, Y, clue(Cx, _, _, [Blank|BlankList])) :-
  Blank = blank(Bx, _),
  Bx is Cx + 1, % Si se cumple esto, entonces es un clue fila.
  notInRow(X, Y, [Blank|BlankList]).
notInClue(X, Y, clue(_, Cy, _, [Blank|BlankList])) :-
  Blank = blank(_, By),
  By is Cy + 1, % Si se cumple esto, entonces es un clue fila.
  notInCol(X, Y, [Blank|BlankList]).

% notInAnyClue(X, Y, C) verifica que el punto (X, Y) no esta en ninguna
% lista de blanks de ningun clue de C.
notInAnyClue(_, _, []).
notInAnyClue(X, Y, [Clue|ClueList]) :-
  notInClue(X, Y, Clue),
  notInAnyClue(X, Y, ClueList).

% clueNotInAnyClue(C1, C2) verifica que ningun clue en C1 se encuentra en
% ninguna lista de blanks de ningun clue de C2.
clueNotInAnyClue([], _).
clueNotInAnyClue([clue(X, Y, _, _)|ClueList], AllClues) :-
  notInAnyClue(X, Y, AllClues),
  clueNotInAnyClue(ClueList, AllClues).

kakuro(Clues) :-
  verifyClues(Clues),
  clueNotInAnyClue(Clues, Clues).



% ================== CORRECTITUD DE UNA SOLUCION ================== %
fill(blank(_, _), N) :- 0 < N, N < 10.

% verifyFills(F) verifica que F es una lista de fills valida.
verifyFills([]).
verifyFills([fill(blank(Fx, Fy), N)|FillList]) :-
  fill(blank(Fx, Fy), N),
  verifyFills(FillList).

% notInFIlls(X, Y, F) verifica que el punto (X, Y) no esta en ningun
% fill de la lista de fills F.
notInAnyFill(_, _, []).
notInAnyFill(X, Y, [fill(blank(Fx, Fy), _)|FillList]) :-
  (X \= Fx ; Y \= Fy),
  notInAnyFill(X, Y, FillList).

% fillNotInAnyFill(F) verifica que no hay dos fill en la misma posicion
% en F.
fillNotInAnyFill([]).
fillNotInAnyFill([fill(blank(X, Y), _)|FillList]) :-
  notInAnyFill(X, Y, FillList),
  fillNotInAnyFill(FillList).

% getFills(B, A, F) es tal que F es la lista de fills respecto a B que
% se encuentran en A.
getFills([], _, []).
getFills([blank(X, Y)|BlankList], AllFills, [fill(blank(X, Y), N)|FillList]) :-
  member(fill(blank(X, Y), N), AllFills),
  getFills(BlankList, AllFills, FillList).

% notSameNumber(F, L) verifica que el numero del fill F no se encuentra en ningun
% fill de la lista L.
notSameNumber(_, []).
notSameNumber(fill(X, N), [fill(_, M)|FillList]) :-
  N \= M,
  notSameNumber(fill(X, N), FillList).

% allNumbersDifferents(F) verifica que no hay dos numeros iguales en los fills de F.
allNumbersDifferents([]).
allNumbersDifferents([Fill|FillList]) :-
  notSameNumber(Fill, FillList),
  allNumbersDifferents(FillList).

% getSum(F, S) es tal que S es la suma de los numero de los fills de F.
getSum([], 0).
getSum([fill(_, N)|FillList], Sum) :-
  M is Sum - N,
  getSum(FillList, M).

% correctClue(C, F) es tal que F son todos los fills y clue cumple con que sus fills
% correspondientes suman el numero del clue y todos tienen numeros distintos.
correctClue(clue(_, _, Sum, BlankList), AllFills) :-
  getFills(BlankList, AllFills, FillList),
  allNumbersDifferents(FillList),
  getSum(FillList, Sum).

% correctAllClues(C, F) es tal que F son todos los fills y todos los clues de C son
% correctos.
correctAllClues([], _).
correctAllClues([Clue|ClueList], AllFills) :-
  correctClue(Clue, AllFills),
  correctAllClues(ClueList, AllFills).

valid(Kakuro, Solution) :-
  kakuro(Kakuro),
  verifyFills(Solution),
  correctAllClues(Kakuro, Solution).



% ================== LECTURA DE UN KAKURO ================== %
readOneTerm(Term) :-
  write('Indique el nombre del archivo:'), nl,
  read(File),
  open(File, read, Stream),
  read(Stream, Term).

readKakuro(Kakuro) :- readOneTerm(Kakuro).
readSolution(Solution) :- readOneTerm(Solution).