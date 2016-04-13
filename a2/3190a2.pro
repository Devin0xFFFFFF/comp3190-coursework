/*
	Comp 3190 Assignment 2 - Devin White
	NOTE: Predicates have been ordered in sections listing their predicates, and you can also enter 'help.' to view all predicates
*/

/*
	Initial Definitions:
		- Define Current Date and Months/Days in a month for age comparison
		- Define Male/Female
		- Define Birthdays
		- Define Deaths
		- Define Parent Relationships
		- Define Marriage relationships / divorces
*/

%DATE CLAUSES - Relates a current date for finding age, and identifies the days in months for more accurate date comparison

current_date(28, 10, 2015).

month(january, 1, 31).
month(february, 2, 28).
month(march, 3, 31).
month(april, 4, 30).
month(may, 5, 31).
month(june, 6, 30).
month(july, 7, 31).
month(august, 8, 31).
month(september, 9, 30).
month(october, 10, 31).
month(november, 11, 30).
month(december, 12, 31).

%PEOPLE CLAUSES - A person is composed of a name, gender, a birthday, with optional parents and marriage/divorce relationships

male(tomas_markham).
male(john_markham).
male(fred_markham).
male(ernie_sanders).
male(ron_markham).
male(jim_markham).
male(phil_markham).
male(cameron_davies).
male(ron_smith).
male(james_reed).
male(brent_markham).
male(timmy_davies).
male(fletcher_smith).
male(bob_reed).
male(joe_reed).

female(eliza_hole).
female(cass_markham).
female(sara_ellis).
female(deloris_cooper).
female(mindy_truman).
female(bella_sanders).
female(connie_markham).
female(tina_markham).
female(gena_headley).
female(wendy_jackson).
female(sally_markham).
female(carly_davies).
female(ella_davies).
female(samantha_davies).
female(victoria_markham-jackson).

birthday(tomas_markham, 6, 1, 1919).
birthday(john_markham, 8, 7, 1944).
birthday(fred_markham, 22, 8, 1948).
birthday(ernie_sanders, 4, 2, 1945).
birthday(ron_markham, 15, 8, 1970).
birthday(jim_markham, 10, 7, 1972).
birthday(phil_markham, 6, 6, 1980).
birthday(cameron_davies, 12, 11, 1978).
birthday(ron_smith, 11, 4, 1968).
birthday(james_reed, 16, 2, 1979).
birthday(brent_markham, 1, 6, 2008).
birthday(timmy_davies, 16, 7, 2004).
birthday(fletcher_smith, 31, 3, 2000).
birthday(bob_reed, 3, 8, 2010).
birthday(joe_reed, 6, 5, 2012).
birthday(eliza_hole, 13, 4, 1920).
birthday(cass_markham, 7, 12, 1946).
birthday(sara_ellis, 28, 3, 1947).
birthday(deloris_cooper, 4, 8, 1948).
birthday(mindy_truman, 6, 6, 1948).
birthday(bella_sanders, 23, 4, 1978).
birthday(connie_markham, 1, 1, 1972).
birthday(tina_markham, 2, 10, 1982).
birthday(gena_headley, 8, 5, 1974).
birthday(wendy_jackson, 9, 6, 1981).
birthday(sally_markham, 19, 11, 2000).
birthday(carly_davies, 4, 8, 2007).
birthday(ella_davies, 7, 1, 2010).
birthday(samantha_davies, 7, 1, 2010).
birthday(victoria_markham-jackson, 9, 9, 2008).

parent(tomas_markham, john_markham).
parent(tomas_markham, cass_markham).
parent(tomas_markham, fred_markham).
parent(eliza_hole, john_markham).
parent(eliza_hole, cass_markham).
parent(eliza_hole, fred_markham).
parent(john_markham, ron_markham).
parent(john_markham, jim_markham).
parent(sara_ellis, ron_markham).
parent(sara_ellis, jim_markham).
parent(ernie_sanders, bella_sanders).
parent(cass_markham, bella_sanders).
parent(fred_markham, connie_markham).
parent(fred_markham, phil_markham).
parent(fred_markham, tina_markham).
parent(deloris_cooper, connie_markham).
parent(mindy_truman, phil_markham).
parent(mindy_truman, tina_markham).
parent(jim_markham, sally_markham).
parent(jim_markham, brent_markham).
parent(gena_headley, sally_markham).
parent(gena_headley, brent_markham).
parent(cameron_davies, carly_davies).
parent(cameron_davies, timmy_davies).
parent(cameron_davies, ella_davies).
parent(cameron_davies, samantha_davies).
parent(bella_sanders, carly_davies).
parent(bella_sanders, timmy_davies).
parent(bella_sanders, ella_davies).
parent(bella_sanders, samantha_davies).
parent(ron_smith, fletcher_smith).
parent(connie_markham, fletcher_smith).
parent(phil_markham, victoria_markham-jackson).
parent(wendy_jackson, victoria_markham-jackson).
parent(james_reed, bob_reed).
parent(james_reed, joe_reed).
parent(tina_markham, bob_reed).
parent(tina_markham, joe_reed).

married(tomas_markham, eliza_hole).
married(john_markham, sara_ellis).
married(ernie_sanders, cass_markham).
married(fred_markham, deloris_cooper).
married(fred_markham, mindy_truman).
married(jim_markham, gena_headley).
married(cameron_davies, bella_sanders).
married(ron_smith, connie_markham).
married(james_reed, tina_markham).
married(phil_markham, wendy_jackson).

divorced(fred_markham, deloris_cooper).
divorced(ron_smith, connie_markham).

/*
	Generic Definitions:
		- Help
		- Person
		- Currently Married, Spouse
		- Time to Days
		- Compare Dates
		- Count Elements in a List
*/

help :- help(_), nl, fail.
help(general) :- write("Each section of help is a list of available predicates, you can look at each section individually by passing the section name to help, 'help(section)'."), nl.
help(clauses) :- write("CLAUSES: current_date(D, M, Y), month(Name, Index, Days), male(X), female(X), birthday(X, D, M, Y), parent(X, Y), married(X, Y), divorced(X, Y)"), nl.
help(generic) :- write("GENERIC: person(X), currently_married(X, Y), spouse(X, Y), months_to_days(M, Days), month_to_days(M, MD), year_to_days(Y, YD), date_to_days(D, M, Y, DAYS), compare_dates(D1, M1, Y1, D2, M2, Y2, Result), count_elems(List, 0, Total), print_list(List)"), nl.
help(print) :- write("PRINT: print_date(D, M, Y), print_birthday(X), print_people, print_parents(X), print_children(X), print_ancestors(X), print_descendants(X), print_relatives(X)"), nl.
help(genetic) :- write("GENETIC: father(X, Y), mother(X, Y), child(X, Y), son(X, Y), daughter(X, Y), grandparent(X, Y), grandfather(X, Y), grandmother(X, Y), sibling(X, Y), brother(X, Y), sister(X, Y), twin(X, Y), ancestor(X, Y), descendant(X, Y), relative(X, Y), related(X, Y)"), nl.
help(marital) :- write("MARITAL: inlaw(X, Y), mother_inlaw(X, Y), father_inlaw(X, Y), brother_inlaw(X, Y), sister_inlaw(X, Y), step_father(X, Y), step_mother(X, Y), step_sibling(X, Y), step_brother(X, Y), step_sister(X, Y), half_sibling(X, Y), half_brother(X, Y), half_sister(X, Y), sibling_spouse(X, Y)"), nl.
help(extended) :- write("EXTENDED: blood_aunt(X, Y), blood_uncle(X, Y), marital_aunt(X, Y), marital_uncle(X, Y), aunt(X, Y), uncle(X, Y), blood_cousin(X, Y), cousin(X, Y), blood_niece(X, Y), blood_nephew(X, Y), marital_niece(X, Y), marital_nephew(X, Y), niece(X, Y), nephew(X, Y)"), nl.
help(age) :- write("AGE: had_birthday_this_year(X), age(X, Age), same_birthday(X, Y), birthday_to_days(X, DAYS), age_gap(X, Y, GAP), older(X, Y), younger(X, Y), same_age(X, Y), oldest(O), youngest(Y)"), nl.
help(count) :- write("COUNT: count_people(Total), count_children(X, Total), count_siblings(X, Total), count_ancestors(X, Total), count_descendants(X, Total)").

person(X) :- male(X).
person(X) :- female(X).

currently_married(X, Y) :- married(X, Y), not(divorced(X, Y)).
currently_married(X, Y) :- married(Y, X), not(divorced(Y, X)).
spouse(X, Y) :- currently_married(X, Y).

calculate_months_in_days(0, Days, Days).
calculate_months_in_days(M, Sum, Days) :- month(_, M, D), Count is Sum + D, Month is M - 1, calculate_months_in_days(Month, Count, Days).

months_to_days(M, Days) :- calculate_months_in_days(M, 0, Days).

month_to_days(M, MD) :- month(_, M, MD).
year_to_days(Y, YD) :- YD is Y * 365.
date_to_days(D, M, Y, DAYS) :- Last_Month is M - 1, months_to_days(Last_Month, MD), year_to_days(Y, YD), DAYS is D + MD + YD. %take M-1 to not include current days


compare_dates(D1, M1, Y1, D2, M2, Y2, Result) :- months_to_days(M1, MD1), months_to_days(M2, MD2), year_to_days(Y1, YD1), year_to_days(Y2, YD2), Result is (D1 - D2) + (MD1 - MD2) + (YD1 - YD2). %positive if Date1 is after Date2

count_elems([], Total, Total).
count_elems([_|Tail], Sum, Total) :- Count is Sum + 1, count_elems(Tail, Count, Total).
count_elems(List, Total) :- count_elems(List, 0, Total).

print_list_div(L) :- L = [_|_], write(", "), print_list(L).
print_list_div([]) :- nl, fail.
print_list([H|T]) :- write(H), print_list_div(T).

/*
	Print Definitions:
		- print_date
		- print_birthday
		- print_people
		- print_parents
		- print_children
		- print_ancestors
		- print_descendants / printfamily
		- print_relatives
*/

print_date(D, M, Y) :- month(MO, M, _), write(MO), write(" "), write(D), write(", "), write(Y), nl.
print_birthday(X) :- birthday(X, D, M, Y), print_date(D, M, Y).
print_people :- findall(X, person(X), List), print_list(List).
print_parents(X) :- findall(Y, parent(Y, X), List), print_list(List).
print_children(X) :- findall(Y, child(Y, X), List), print_list(List).
print_ancestors(X) :- findall(Y, ancestor(Y, X), List), print_list(List).
print_descendants(X) :- findall(Y, descendant(Y, X), List), print_list(List).
printfamily(X) :- print_descendants(X).
print_relatives(X) :- findall(Y, relative(Y, X), L), print_list(L).

/*
	Genetic:
		- Father, Mother, Same Father/Mother
		- Child, Son, Daughter
		- Grandparent, Grandmother, Grandfather
		- Sibling, Brother, Sister, Twin
		- Ancestor, Descendant
		- Relative / Related
*/

father(X, Y) :- parent(X, Y), male(X).
mother(X, Y) :- parent(X, Y), female(X).
same_father(X, Y) :- father(F, Y), father(F, X).
same_mother(X, Y) :- mother(M, Y), mother(M, X).

child(X, Y) :- parent(Y, X).
son(X, Y) :- male(X), child(X, Y).
daughter(X, Y) :- female(X), child(X, Y).

grandparent(X, Y) :- parent(X, Z), parent(Z, Y).
grandfather(X, Y) :- father(X, Z), parent(Z, Y).
grandmother(X, Y) :- mother(X, Z), parent(Z, Y).

sibling(X, Y) :- same_father(X, Y), same_mother(X, Y), X\=Y.
brother(X, Y) :- male(X), sibling(X, Y).
sister(X, Y) :- female(X), sibling(X, Y).
twin(X, Y) :- sibling(X, Y), same_birthday(X, Y).

ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

descendant(X, Y) :- child(X, Y).
descendant(X, Y) :- child(X, Z), descendant(Z, Y).

relative(X, Y) :- X\=Y.
relative(X, Y) :- ancestor(X, Y). %parent, parent of parent
relative(X, Y) :- descendant(X, Y). %child, child of child
relative(X, Y) :- sibling(X, Y).
relative(X, Y) :- half_sibling(X, Y).
relative(X, Y) :- blood_aunt(X, Y).
relative(X, Y) :- blood_uncle(X, Y).
relative(X, Y) :- blood_cousin(X, Y).
relative(X, Y) :- blood_niece(X, Y).
relative(X, Y) :- blood_nephew(X, Y).

related(X, Y) :- relative(X, Y).

/*
	Marital:
		- Inlaw, Mother/Father/Brother/Sister Inlaw
		- Step Father/Mother, Step Sibling, Step Brother/Sister
		- Half Sibling, Half Brother/Sister
		- Sibling Spouse
*/

inlaw(X, Y) :- currently_married(Z, Y), parent(X, Z).
mother_inlaw(X, Y) :- currently_married(Z, Y), mother(X, Z).
father_inlaw(X, Y) :- currently_married(Z, Y), father(X, Z).
brother_inlaw(X, Y) :- currently_married(Z, Y), brother(X, Z).
sister_inlaw(X, Y) :- currently_married(Z, Y), sister(X, Z).

step_father(X, Y) :- mother(M, Y), currently_married(X, M), not(parent(X, Y)).
step_mother(X, Y) :- father(F, Y), currently_married(X, F), not(parent(X, Y)).

step_sibling(X, Y) :- father(F, X), step_father(F, Y).
step_sibling(X, Y) :- mother(F, X), step_mother(F, Y).

step_brother(X, Y) :- male(X), step_sibling(X, Y).
step_sister(X, Y) :- female(X), step_sibling(X, Y).

half_sibling(X, Y) :- same_father(X, Y), not(same_mother(X, Y)), X\=Y.
half_sibling(X, Y) :- same_mother(X, Y), not(same_father(X, Y)), X\=Y.

half_brother(X, Y) :- male(X), half_sibling(X, Y).
half_sister(X, Y) :- female(X), half_sibling(X, Y).

sibling_spouse(X, Y) :- sibling(S, Y), spouse(S, X).

/*
	Extended:
		- Blood Aunt/Uncle
		- Marital Aunt/Uncle
		- Aunt, Uncle
		- Blood Cousin / Cousin
		- Blood Niece/Nephew, Marital Niece/Nephew
		- Niece, Nephew
*/

blood_aunt(X, Y) :- parent(Z, Y), sister(X, Z).
blood_uncle(X, Y) :- parent(Z, Y), brother(X, Z).

marital_aunt(X, Y) :- currently_married(X, U), parent(P, Y), brother(U, P).
marital_uncle(X, Y) :- currently_married(X, A), parent(P, Y), sister(A, P).

aunt(X, Y) :- blood_aunt(X, Y).
aunt(X, Y) :- marital_aunt(X, Y).

uncle(X, Y) :- blood_uncle(X, Y).
uncle(X, Y) :- marital_uncle(X, Y).

blood_cousin(X, Y) :- parent(Z, X), parent(M, Y), sibling(Z, M).

cousin(X, Y) :- aunt(A, Y), child(X, A).
cousin(X, Y) :- uncle(U, Y), child(X, U).

blood_niece(X, Y) :- female(X), parent(P, X), sibling(Y, P).
blood_nephew(X, Y) :- male(X), parent(P, X), sibling(Y, P).

marital_niece(X, Y) :- currently_married(Z, Y), blood_niece(X, Z).
marital_niece(X, Y) :- female(X), sibling(S, Y), parent(P, X), currently_married(P, S).
marital_nephew(X, Y) :- currently_married(Z, Y), blood_nephew(X, Z).
marital_nephew(X, Y) :- male(X), sibling(S, Y), parent(P, X), currently_married(P, S).

niece(X, Y) :- blood_niece(X, Y).
niece(X, Y) :- marital_niece(X, Y).
nephew(X, Y) :- blood_nephew(X, Y).
nephew(X, Y) :- marital_nephew(X, Y).

/*
	Age:
		- Had Birthday This Year
		- Age
		- Same Birthday
		- Birthday to Days
		- Age Gap
		- Older/Younger, Same Age
		- Oldest/Youngest
*/

had_birthday_this_year(X) :- birthday(X, D, M, _), current_date(DX, DM, _), compare_dates(D, M, 0, DX, DM, 0, Result), Result < 1. 

age(X, Age) :- birthday(X, _, _, Y), current_date(_, _, CY), had_birthday_this_year(X), Age is CY - Y.
age(X, Age) :- birthday(X, _, _, Y), current_date(_, _, CY), not(had_birthday_this_year(X)), Age is CY - Y - 1.

same_birthday(X, Y) :- birthday(X, D, M, _), birthday(Y, D, M, _), X\=Y.

birthday_to_days(X, DAYS) :- birthday(X, DX, MX, _), age(X, AGEX), date_to_days(DX, MX, AGEX, DAYS).

age_gap(X, Y, GAP) :- birthday_to_days(X, DAYSX), birthday_to_days(Y, DAYSY), GAP is DAYSX - DAYSY.

older(X, Y) :- age_gap(X, Y, Gap), Gap > 0.
younger(X, Y) :- age_gap(X, Y, Gap), Gap < 0.
same_age(X, Y) :- age(X, AX), age(Y, AY), AX =:= AY, X\=Y.

oldest(O) :- findall(X, person(X), L), [H|T] = L, find_oldest(T, H, O).
find_oldest([], Oldest, Oldest).
find_oldest([H|T], O, Oldest) :- older(H, O), find_oldest(T, H, Oldest).
find_oldest([H|T], O, Oldest) :- older(O, H), find_oldest(T, O, Oldest).

youngest(Y) :- findall(X, person(X), L), [H|T] = L, find_youngest(T, H, Y).
find_youngest([], Youngest, Youngest).
find_youngest([H|T], Y, Youngest) :- younger(H, Y), find_youngest(T, H, Youngest).
find_youngest([H|T], Y, Youngest) :- younger(Y, H), find_youngest(T, Y, Youngest).

/*
	Counts:
		- Count People
		- Count Children
		- Count Siblings
		- Count Ancestors
		- Count Descendants
*/

count_people(Total) :- findall(X, person(X), C), count_elems(C, Total).
count_children(X, Total) :- findall(Y, child(Y, X), C), count_elems(C, Total).
count_siblings(X, Total) :- findall(Y, sibling(Y, X), C), count_elems(C, Total).
count_ancestors(X, Total) :- findall(Y, ancestor(Y, X), C), count_elems(C, Total).
count_descendants(X, Total) :- findall(Y, descendant(Y, X), C), count_elems(C, Total).

/*
TEST CASES---------------------------------------------------------------------------------------------------------------

?- male(ron_smith).
true.

?- parent(bella_sanders, X).
X = carly_davies ;
X = timmy_davies ;
X = ella_davies ;
X = samantha_davies.

?- currently_married(tomas_markham, eliza_hole).
true ;
false.

?- currently_married(eliza_hole, tomas_markham).
true.

?- count_descendants(tomas_markham, Descendants).
Descendants = 19.

?- count_people(People).
People = 30.

?- same_age(ella_davies, Y).
Y = bob_reed ;
Y = samantha_davies ;
false.

?- same_age(X, Y).
X = Y, Y = tomas_markham ;
X = Y, Y = john_markham ;
X = Y, Y = fred_markham ;
X = fred_markham,
Y = deloris_cooper ;
X = fred_markham,
Y = mindy_truman .

?- youngest(Youngest).
Youngest = joe_reed .

?- oldest(Oldest).
Oldest = tomas_markham.

?- age(eliza_hole, Age).
Age = 95 .

?- aunt(X, victoria_markham-jackson).
X = tina_markham ;
false.

?- half_sister(X, Y).
X = connie_markham,
Y = phil_markham ;
X = connie_markham,
Y = tina_markham ;
X = tina_markham,
Y = connie_markham ;
false.

?- brother_inlaw(X, mindy_truman).
X = john_markham ;
false.

?- relative(bob_reed, phil_markham).
true .

?- twin(X, Y).
X = samantha_davies,
Y = ella_davies ;
X = ella_davies,
Y = samantha_davies ;
false.

?- daughter(X, cass_markham).
X = bella_sanders ;
false.

?- father(X, cass_markham).
X = tomas_markham ;
false.

?- printfamily(tomas_markham).
john_markham, cass_markham, fred_markham, ron_markham, jim_markham, bella_sanders, connie_markham, phil_markham, tina_markham, sally_markham, brent_markham, carly_davies, timmy_davies, ella_davies, samantha_davies, fletcher_smith, victoria_markham-jackson, bob_reed, joe_reed
false.

?- print_children(fred_markham).
connie_markham, phil_markham, tina_markham
false.

?- print_birthday(sally_markham).
november 19, 2000
true.

?- ancestor(X, ella_davies).
X = cameron_davies ;
X = bella_sanders ;
X = tomas_markham ;
X = eliza_hole ;
X = ernie_sanders ;
X = cass_markham ;
false.

*/