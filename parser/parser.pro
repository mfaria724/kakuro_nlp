% ======================== PARSING DE ORACIONES ======================== %

% inicio de la gramática.
start(Tokens) --> sentences(Tokens).

% cada frase puede contener 1 o varias oraciones.
sentences([sentences, Sentences]) --> sentence(Sentences).
sentences([sentences, [Sentence, Connector, Sentences]]) --> 
  sentence(Sentence),
  connector(Connector), 
  sentences(Sentences).

% hay dos tipos de oraciones: tercera persona singular y normales (todas las 
% que no están en tercera persona singular).
sentence([sentence, Sentence]) --> third_person_sing_sentence(Sentence).
sentence([sentence, Sentence]) --> normal_sentence(Sentence).

% si el sujeto de la oración es de la tercera persona singular, hay que revisar
% el tiempo gramatical de la oración.
third_person_sing_sentence([Subj, Verb, Comp]) --> 
  subject_third_person_sing(Subj),
  verb_third_person_sing(Verb),
  complt(Comp). 
third_person_sing_sentence([Subj, Verb, Comp]) --> 
  subject_third_person_sing(Subj),
  future_verb(Verb),
  complt(Comp). 

% si la oración es normal, está compuesta por 3 componentes: sujeto, verbo y 
% complemento. El complemento puede ser vacio.
normal_sentence([Subj, Verb, Comp]) --> 
  normal_subject(Subj), 
  normal_verb(Verb), 
  complt(Comp).

% ======================== PARSING DEL SUJETO ======================== %

% los sujetos normales pueden estar compuestos por si mismos y una frase 
% complementaria.
normal_subject([NormalSubj, NounPhrase]) --> 
  normal_subject_comp(NormalSubj), 
  noun_phrase(NounPhrase).

% las frases complemenatias pueden contener conectores o no, por lo que puede 
% ser un sujeto simple.
normal_subject_comp(Subject) --> simplex_pronoun(Subject).
normal_subject_comp([subject_comp, [Subject, Connector, Subject2|OtherSubjects]]) --> 
  subject(Subject), 
  connector(Connector), 
  subject(Subject2), 
  plural_subject(OtherSubjects).

% si el sujeto es plural (puede estar compuesto por dos nombres que representen
% tokens en tercera persona del singular y algún conector) se agregan al final
% de la definición de sujeto.
plural_subject([]) --> [].
plural_subject([Connector, Subject|OtherSubjects]) --> 
  connector(Connector), 
  subject(Subject), 
  plural_subject(OtherSubjects).

% identifica si el sujeto está en la tercera persona del singular o si 
% es cualquier otro nombre.
subject([subject, [Adjectives, Noun]]) --> 
  adjectives(Adjectives), 
  noun(Noun).
subject([subject, [Adjectives, PronounThirdPerson]]) --> 
  adjectives(Adjectives), 
  pronoun_third_person_sing(PronounThirdPerson).
subject([subject, [Adjectives, NameThirdPersonSingular]]) --> 
  adjectives(Adjectives), 
  name_third_person_sing_comp(NameThirdPersonSingular).

% ========================== PARSING DEL VERBO ========================== %

% representa los verbos que están compuestos por una sola palabra.
normal_verb(Verb) --> future_verb(Verb).
normal_verb(Verb) --> verb(Verb).

% especialización de los verbos de una sola palabra.
verb(Verb) --> past_verb(Verb).
verb(Verb) --> present_verb(Verb).

% los verbos en futuro poseen dos auxiliares distintos: 'will' y 'will not'
% una vez que se identifica el verbo auxiliar, el resto es parseado como si 
% fuera un verbo en presente.
future_verb([future_verb, [[aux_verb, will], Verb]]) --> 
  [will], 
  present_verb(Verb). 
future_verb([future_verb, [[aux_verb, 'will not'], Verb]]) --> 
  [will], 
  [not], 
  present_verb(Verb). 

% ======================== PARSING DEL COMPLEMENTO ======================== %

% verifica si el complemento es vacío.
complt([complement, []]) --> [].
complt([complement, [Nouns, Adverbs]]) --> noun_list(Nouns), adverbs(Adverbs). 

% los adverbios son parseados como una lista infinita de adverbios.
adverbs([adverbs, []]) --> [].
adverbs([adverbs, [Adverb|OtherAdverbs]]) --> 
  adverb(Adverb), 
  adverbs(OtherAdverbs).

% cada averbio puede contener preposiciones y se diferencias los de tiempo
% con los de lugar para restrigir estas preposiciones.
adverb([adverb, [PlacePreposition, Article, Place]]) --> 
  place_adverb_preposition(PlacePreposition), 
  article(Article), 
  place(Place).
adverb([adverb, [TimePreposition, Article, Time]]) --> 
  time_adverb_preposition(TimePreposition), 
  article(Article), 
  time_adverb(Time).
adverb([adverb, [Time]]) --> time_adverb(Time).

% los sustantivos pueden ser vacíos por la definición de la gramática.
% tambien pueden ser tokens individuales o una lista de tokens unidos por un
% conector.
noun_list([nouns, []]) --> [].
noun_list([nouns, [NounStruct]]) --> noun_struct(NounStruct).
noun_list([nouns, [NounStruct, Connector|Others]]) --> 
  noun_struct(NounStruct), 
  connector(Connector), 
  noun_list(Others).
noun_list([nouns, [NounStruct|Others]]) --> 
  noun_struct(NounStruct), 
  noun_list(Others).

% cada nombre puede tener preposiciones, articulos y adjetivos asociados a el.
% adicionalmente, pueden ser compuestos. 
noun_struct([noun_struct, [Preposition, Article, Adjectives, NormalSubjectComp]]) --> 
  preposition(Preposition), 
  article(Article), 
  adjectives(Adjectives), 
  normal_subject_comp(NormalSubjectComp).
noun_struct([noun_struct, [Preposition, Article, Adjectives, Nouns]]) --> 
  preposition(Preposition), 
  article(Article), 
  adjectives(Adjectives), 
  nouns(Nouns). 
noun_struct([noun_struct, [Preposition, Article, Adjectives, NameThirdPerson]]) --> 
  preposition(Preposition), 
  article(Article), 
  adjectives(Adjectives), 
  name_third_person_sing_comp_not_empty(NameThirdPerson).

% pueden ser utilizados nombres en tercera persona como sustantivos
% en frases como 'whit Manuel'. 
name_third_person_sing_comp_not_empty(Name) --> name_third_person_sing(Name). 
name_third_person_sing_comp_not_empty([Name|Others]) --> 
  name_third_person_sing(Name), name_third_person_sing_comp_not_empty(Others).

% los nombres pueden ser individuales o compuestos, como 'Amin' o 'Amin Lorenzo'
nouns([nouns, [Noun]]) --> noun(Noun).
nouns([nouns, [Noun|Others]]) --> noun(Noun), nouns(Others).

% si el sujeto de es de la tercera persona del sigular, puede ser un nombre
% individual o un pronombre que lo represente.
subject_third_person_sing([subject, [Adjectives, Pronoun, Noun]]) --> 
  adjectives(Adjectives),
  pronoun_third_person_sing_comp(Pronoun),
  noun_phrase(Noun).
subject_third_person_sing([subject, [Adjectives, Pronoun, Noun]]) --> 
  adjectives(Adjectives),
  name_third_person_sing_comp(Pronoun),
  noun_phrase(Noun).

% los noun phrases representan descripciones de sujetos, como 'Alex the gamer'
noun_phrase([noun_phrase, []]) --> []. 
noun_phrase([noun_phrase, [Article, Adjectives, Noun]]) --> 
  article(Article), 
  adjectives(Adjectives), 
  noun_comp(Noun).

% los adjetivos pueden no aparecer, aparecer una vez o múltiples veces.
adjectives([adjectives, []]) --> [].
adjectives([adjectives, [Adjective|Others]]) --> 
  adjective(Adjective), 
  adjectives(Others).

% los nombres en tercera persona singular pueden representar pueden tener más
% de una palabra y seguir representando a una sola persona u objeto.
pronoun_third_person_sing_comp(Pronoun) --> pronoun_third_person_sing(Pronoun). 
pronoun_third_person_sing_comp([Pronoun|Others]) --> 
  pronoun_third_person_sing(Pronoun), pronoun_third_person_sing_comp(Others).

% para la verificación en el predicado, podría ser vacío. Si es el sujeto de la 
% oración, no. Por esta razón se hace la distinción y se usa este predicado en
% el predicado.
name_third_person_sing_comp([]) --> [].
name_third_person_sing_comp(Name) --> name_third_person_sing_comp_not_empty(Name).

% se revisa si se tiene un nombre compuesto (como 'Comedores MYS') o individual
% (como 'HBO').
noun_comp(Noun) --> noun(Noun).
noun_comp([noun_comp, [Noun|Others]]) --> noun(Noun), noun_comp(Others).

% los sustantivos pueden ser de lugar, tiempo o un nombre propio. Se hace la
% diferencia porque podemos hablar de cosas como 'yesterday' usandolo como un
% adverbio de tiempo o como un sustantivo (si hablamos 'del ayer').
noun([noun, Place]) --> place(Place).
noun([noun, Time]) --> time(Time).
noun([noun, ProperNoun]) --> proper_noun(ProperNoun). 

% ======================== VOCABULARIO ======================== % 

% nodo terminal para pronombres de la tercera persona singular.
pronoun_third_person_sing([pronoun, PR]) --> 
  [PR], { pronoun_third_person_sing(PR) }.
pronoun_third_person_sing(he).
pronoun_third_person_sing(she).
pronoun_third_person_sing(it).
pronoun_third_person_sing('He').
pronoun_third_person_sing('She').
pronoun_third_person_sing('It').

% nodo terminal para pronombres que no cumplen con la tercera persona del 
% singular. 
simplex_pronoun([simplex, SUB]) --> [SUB], { simplex_pronoun(SUB) }.
simplex_pronoun('I').
simplex_pronoun('You').
simplex_pronoun(you).
simplex_pronoun('We').
simplex_pronoun(we).
simplex_pronoun('They').
simplex_pronoun(they).

% nodo terminal para verbos conjugados en presente.
present_verb([present_verb, V]) --> [V], { present_verb(V) }.
present_verb(like).
present_verb(read).
present_verb(watch).
present_verb(present).
present_verb(eat).
present_verb(work).
present_verb(play).
present_verb(sell).
present_verb(make).
present_verb(get).
present_verb(cook).
present_verb(play).

% nodo terminal para verbos conjugados en pasado.
past_verb([past_verb, V]) --> [V], { past_verb(V) }.
past_verb(made).
past_verb(worked).
past_verb(sold).
past_verb(got).
past_verb(cooked).
past_verb(played).

% nodo terminal para adverbios de tiempo.
time_adverb([time, A]) --> [A], { time_adverb(A) }.
time_adverb(today).
time_adverb(yesterday).
time_adverb(tomorrow).
time_adverb(afternoon).

% nodo terminal para preposiciones de adverbios de lugar.
place_adverb_preposition([place_preposition, AP]) --> [AP], { place_adverb_preposition(AP) }.
place_adverb_preposition(in).

% nodo terminal para preposiciones de adverbios de tiempo.
time_adverb_preposition([time_preposition, AP]) --> [AP], { time_adverb_preposition(AP) }.
time_adverb_preposition(in).

% nodo terminal para preposiciones.
preposition([preposition, []]) --> [].
preposition([preposition, P]) --> [P], { preposition(P) }.
preposition(for).
preposition(at).
preposition(with).

% nodo terminal para nombres que representen a la tercera persona singular.
name_third_person_sing([name, PR]) --> [PR], { name_third_person_sing(PR) }.
name_third_person_sing('Alex').
name_third_person_sing('Amin').
name_third_person_sing('Manuel').
name_third_person_sing('Zack').
name_third_person_sing('Snyder').
name_third_person_sing('Jared').
name_third_person_sing('Carlos').
name_third_person_sing('Daniel').

% nodo terminal para artículos.
article([article, []]) --> [].
article([article, AR]) --> [AR], { article(AR) }.
article(the).
article(a).

% nodo terminal para adjetivos.
adjective([adjective, AD]) --> [AD], { adjective(AD) }.
adjective(young).
adjective(little).
adjective(new).
adjective(great).
adjective(nice).
adjective(good).

% nodo terminal para palabras que puedan ser usadas como sustantivos.
proper_noun([proper_noun, N]) --> [N], { proper_noun(N) }.
proper_noun(student).
proper_noun(films).
proper_noun(film).
proper_noun(books).
proper_noun(book).  
proper_noun(music).
proper_noun(project).
proper_noun(class).
proper_noun(gamer).
proper_noun(grade).
proper_noun(games).
proper_noun('Chivo').
proper_noun('HBO').
proper_noun('Justice').
proper_noun('League').
proper_noun('Bamboo').
proper_noun('Postres').
proper_noun('Coco').
proper_noun('Amazon').
proper_noun('MAC').
proper_noun('Apure').
proper_noun('Caracas').

% nodo terminal para adverbios de lugar.
place([place, N]) --> [N], { place(N) }.
place(comedor).
place('HBO').
place('MYS').
place('Comedores').

% nodo terminal para adverbios de tiempo.
time([time, N]) --> [N], { time(N) }.
time(yesterday).
time(tomorrow).
time(afternoon).

% nodo terminar para verbos conjugados en la tercera persona del singular
% en presente.
verb_third_person_sing(Verb) --> past_verb(Verb).
verb_third_person_sing([conjugated_verb, VERB]) --> [VERB], { verb_third_person_sing(VERB) }.
verb_third_person_sing(likes).
verb_third_person_sing(reads).
verb_third_person_sing(watches).
verb_third_person_sing(cooks).
verb_third_person_sing(presents).
verb_third_person_sing(eats).
verb_third_person_sing(works).
verb_third_person_sing(plays).

% nodo terminal para conectores.
connector([connector, C]) --> [C], { connector(C) }.
connector(,).
connector(and).
connector(while).

% ========== INICIALIZADOR DEL PARSER ========== %
main(String) :-
  atomic_list_concat(Tokens, ' ', String),
  start(Route, Tokens, []), write(Route), !.
