start --> sentences.

sentences --> sentence.
sentences --> sentence, connector, sentences.

sentence --> third_person_sing_sentence.
sentence --> normal_sentence.

normal_sentence --> normal_subject, normal_verb, complt.

normal_subject --> normal_subject_comp, noun_phrase.

normal_subject_comp --> simplex_pronoun.
normal_subject_comp --> subject, connector, subject, plural_subject.

simplex_pronoun --> [SUB], { simplex_pronoun(SUB) }.
simplex_pronoun('I').
simplex_pronoun('You').
simplex_pronoun(you).
simplex_pronoun('We').
simplex_pronoun(we).
simplex_pronoun('They').
simplex_pronoun(they).

plural_subject --> [].
plural_subject --> connector, subject, plural_subject.

subject --> adjectives, noun.
subject --> adjectives, pronoun_third_person_sing.
subject --> adjectives, name_third_person_sing_comp.

normal_verb --> future_verb.
normal_verb --> verb.

verb --> past_verb.
verb --> present_verb.

future_verb --> [will], present_verb. 
future_verb --> [will], [not], present_verb. 

present_verb --> [V], { present_verb(V) }.
present_verb(like).
present_verb(read).
present_verb(watch).
present_verb(present).
present_verb(eat).
present_verb(work).
present_verb(play).
present_verb(sell).

past_verb --> [V], { past_verb(V) }.
past_verb(made).
past_verb(worked).
past_verb(sold).

complt --> [].
complt --> noun_list, adverbs. 

adverbs --> [].
adverbs --> adverb, adverbs.

adverb --> place_adverb_preposition, article, place.
adverb --> time_adverb_preposition, article, time_adverb.
adverb --> time_adverb.

time_adverb --> [A], { time_adverb(A) }.
time_adverb(today).
time_adverb(yesterday).
time_adverb(tomorrow).
time_adverb(afternoon).

place_adverb_preposition --> [AP], { place_adverb_preposition(AP) }.
place_adverb_preposition(in).

time_adverb_preposition --> [AP], { time_adverb_preposition(AP) }.
time_adverb_preposition(in).

noun_list --> [].
noun_list --> noun_struct.
noun_list --> noun_struct, connector, noun_list.
noun_list --> noun_struct, noun_list.

preposition --> [].
preposition --> [P], { preposition(P) }.
preposition(for).
preposition(at).
preposition(with).

noun_struct --> preposition, article, adjectives, normal_subject_comp.
noun_struct --> preposition, article, adjectives, nouns. % te acabo de poner
noun_struct --> 
  preposition, 
  article, 
  adjectives, 
  name_third_person_sing_comp_not_empty.

name_third_person_sing_comp_not_empty --> name_third_person_sing. 
name_third_person_sing_comp_not_empty --> 
  name_third_person_sing, name_third_person_sing_comp_not_empty.

nouns --> noun.
nouns --> noun, nouns.

third_person_sing_sentence --> 
  subject_third_person_sing,
  verb_third_person_sing,
  complt. 
third_person_sing_sentence --> 
  subject_third_person_sing,
  future_verb,
  complt. 

subject_third_person_sing --> 
  adjectives,
  pronoun_third_person_sing_comp,
  noun_phrase.
subject_third_person_sing --> 
  adjectives,
  name_third_person_sing_comp,
  noun_phrase.

noun_phrase --> []. 
noun_phrase --> article, adjectives, noun_comp.

adjectives --> [].
adjectives --> adjective, adjectives.

pronoun_third_person_sing_comp --> pronoun_third_person_sing. 
pronoun_third_person_sing_comp --> 
  pronoun_third_person_sing, pronoun_third_person_sing_comp.

pronoun_third_person_sing --> [PR], { pronoun_third_person_sing(PR) }.
pronoun_third_person_sing(he).
pronoun_third_person_sing(she).
pronoun_third_person_sing(it).
pronoun_third_person_sing('He').
pronoun_third_person_sing('She').
pronoun_third_person_sing('It').

name_third_person_sing_comp --> [].
name_third_person_sing_comp --> name_third_person_sing_comp_not_empty.

name_third_person_sing --> [PR], { name_third_person_sing(PR) }.
name_third_person_sing('Alex').
name_third_person_sing('Amin').
name_third_person_sing('Manuel').
name_third_person_sing('Zack').
name_third_person_sing('Snyder').
name_third_person_sing('Jared').
name_third_person_sing('Carlos').
name_third_person_sing('Daniel').

article --> [].
article --> [AR], { article(AR) }.
article(the).
article(a).

adjective --> [AD], { adjective(AD) }.
adjective(young).
adjective(little).
adjective(new).
adjective(great).

noun_comp --> noun.
noun_comp --> noun, noun_comp.

noun --> place.
noun --> time.
noun --> proper_noun. 

proper_noun --> [N], { proper_noun(N) }.
proper_noun(student).
proper_noun(films).
proper_noun(film).
proper_noun(books).
proper_noun(book).  
proper_noun(music).
proper_noun(project).
proper_noun(class).
proper_noun(gamer).
proper_noun('HBO').
proper_noun('Justice').
proper_noun('League').
proper_noun('Bamboo').
proper_noun('Postres').

place --> [N], { place(N) }.
place(comedor).
place('HBO').
place('MYS').
place('Comedores').

time --> [N], { time(N) }.
time(yesterday).
time(tomorrow).
time(afternoon).

verb_third_person_sing --> past_verb.
verb_third_person_sing --> [VERB], { verb_third_person_sing(VERB) }.
verb_third_person_sing(likes).
verb_third_person_sing(reads).
verb_third_person_sing(watches).
verb_third_person_sing(presents).
verb_third_person_sing(eats).
verb_third_person_sing(works).
verb_third_person_sing(plays).

connector --> [C], { connector(C) }.
connector(,).
connector(and).
connector(while).
