/*
	COMP 3190 A3 - (Enter 'run.' to execute command line interface)
	
	Author: Devin White
	Date: 29-11-2015
	
	An expert system for deciding which objective to pursue in an environment.
		- Two teams of 3, multiple objectives, located on an n*m mapped environment
		- Units have a set vision range, must estimate opponent positions out of range
		- Units have statistics which define their value in a given situation
		- Players control units, players have performance statistics which define their value
*/

%Declaration for dynamic predicates
:- dynamic probable_position/4, estimated_position/4, optimal_objective/2.

/*
****************************************************
*	General Predicates
****************************************************
*/

time(4, 32). % minutes and seconds

map(12, 12). %length and width

/*
****************************************************
*	Entity Predicates
****************************************************
*/

objective(boss, 100). %objective and value
objective(treasure, 30).
objective(monster, 40).

objective_difficulty(boss, P, D) :- time(M, _), player(P, H), hero_scale(S, H), D is (M * 5) / S. %objective and difficulty calculation
objective_difficulty(treasure, _, 10).
objective_difficulty(monster, _, 50).

team(dev, radiant). %player and team
team(ben, radiant).
team(cam, radiant).
team(bob, dire).
team(joe, dire).
team(tom, dire).

player(dev, x). %player and hero
player(ben, y).
player(cam, z).
player(bob, a).
player(joe, b).
player(tom, c).

player_stats(dev, 4, 0, 2345). %player, Wins, Losses, MMR (Match Making Rating)
player_stats(ben, 15, 7, 3002).
player_stats(cam, 3, 1, 2300).
player_stats(bob, 6, 6, 2414).
player_stats(joe, 3, 8, 1983).
player_stats(tom, 17, 4, 3150).

player_game_stats(dev, 5, 2, 6). %player, Kills, Deaths, Assists
player_game_stats(ben, 2, 1, 4).
player_game_stats(cam, 0, 6, 2).
player_game_stats(bob, 8, 0, 3).
player_game_stats(joe, 4, 5, 5).
player_game_stats(tom, 0, 2, 2).

hero_stats(x, 3, 1). %hero, carry rating, support rating
hero_stats(y, 2, 2).
hero_stats(z, 3, 1).
hero_stats(a, 1, 3).
hero_stats(b, 3, 1).
hero_stats(c, 2, 2).

/*
****************************************************
*	Position Predicates
****************************************************
*/

position(boss, 10, 10). %entity, X, Y
position(treasure, 1, 1).
position(monster, 4, 7).

position(dev, 0, 0).
position(ben, 2, 3).
position(cam, 4, 5).

position(bob, 10, 1).
position(joe, 6, 6).
position(tom, 9, 6).

last_seen(tom, 8, 7, 4, 30). %player, X, Y, Time (Minutes, Seconds)
last_seen(dev, 1, 6, 4, 28).

/*
****************************************************
*	Utility
*		- General use rules
****************************************************
*/

y_n(MSG) :- write(MSG), write(" (y/n)"), read(IN), string_codes(IN, [C|_]), C = 121. %121 = "y"

get_list_max(MAX, VAL, []) :- MAX is VAL.
get_list_max(MAX, VAL, [H|T]) :- (H > VAL, get_list_max(MAX, H, T)) ; get_list_max(MAX, VAL, T).

map_bound_x(BX, X) :- map(W, _), bound(X, 0, W, BX).
map_bound_y(BY, Y) :- map(_, H), bound(Y, 0, H, BY).
bound(VAR, LB, UB, OUT) :- (VAR < LB, OUT is LB) ; (VAR > UB, OUT is UB) ; OUT is VAR.

time_in_seconds(Seconds, H, M, S) :- Seconds is (H * 3600) + (M * 60) + S.

difference_in_time(D, H1, M1, S1, H2, M2, S2) :- time_in_seconds(T1, H1, M1, S1), time_in_seconds(T2, H2, M2, S2), D is T2 - T1.
difference_from_current_time(D, H, M, S) :- time(TM, TS), difference_in_time(D, H, M, S, 0, TM, TS).

not_on_team(P, TEAM) :- team(P, _), not(team(P, TEAM)).

trim_last_list_element(IN, OUT) :- nl, trim_last_list_element(IN, OUT, []).
trim_last_list_element([_|[]], OUT, L) :- OUT = L.
trim_last_list_element([H|T], OUT, L) :- append([H], L, List), trim_last_list_element(T, OUT, List).

/*
****************************************************
*	Distance and Vision
*		- Straight Line Distance Calculations
*		- Visiblity checks
****************************************************
*/

distance(D, X1, Y1, X2, Y2) :- D is sqrt(((X2 - X1) * (X2 - X1)) + ((Y2 - Y1) * (Y2 - Y1))).
distance(D, P1, P2) :- position(P1, X1, Y1), position(P2, X2, Y2), distance(D, X1, Y1, X2, Y2).
distance(D, P, X, Y) :- position(P, X1, Y1), distance(D, X1, Y1, X, Y).

in_range(P2, P1, MAX) :- distance(D, P2, P1), D < MAX.
in_range(P, X, Y, MAX) :- position(P, X1, Y1), distance(D, X, Y, X1, Y1), D < MAX.

in_visibility_range(P2, P1) :- max_visibility_distance(DMAX), in_range(P2, P1, DMAX).

visible_position(X, Y, TEAM) :- team(Z, TEAM), max_visibility_distance(DMAX), in_range(Z, X, Y, DMAX), !.

visible(X, TEAM) :- team(X, TEAM) ; (team(P, TEAM), in_visibility_range(X, P)).

not_visible(X, TEAM) :- team(X, _), not(visible(X, TEAM)).

visibly_unoccupied(X, Y, TEAM) :- not(visible_position(X, Y, TEAM)), not(visibly_occupied(X, Y,TEAM)),  not(probable_position(_, X, Y, _)).

visibly_occupied(X, Y, TEAM) :- (objective(O, _), position(O, X, Y)) ; (visible_position(X, Y, TEAM), position(_, X, Y)).

missing(P, TEAM) :- not_visible(P, TEAM) ; not(probable_position(P, _, _, _)).

last_seen_cf(CF, P) :- last_seen(P, _, _, Min, Sec), difference_from_current_time(S, 0, Min, Sec), last_seen_decay_factor(SF), CF is (SF ^ S).

/*
****************************************************
*	Choose Probable Position
*		- Take either an estimated position from the user, or last seen scaled by time, or default to any position on the map
*		- Use the CF to generate all valid positions based on a given start position
*		- Rank each possible position based on its distance to objective, and the confidence rating (how confident a team is based on their positions and enemy positions)
*		- Select the most probable (highest ranked) position for that player
****************************************************
*/

choose_probable_position(P, OBJ, TEAM) :- ((estimated_position(P, X, Y, CF), choose_probable_position(P, X, Y, CF, OBJ, TEAM)) ;
(last_seen(P, X, Y, _, _), last_seen_cf(CF, P), choose_probable_position(P, X, Y, CF, OBJ, TEAM), !)
 ; (choose_default_probable_position(P, OBJ, TEAM))
 ), !.
choose_default_probable_position(P, OBJ, TEAM) :- map(MX, MY), max_visibility_distance(V), X is MX + V + 1, Y is MY + V + 1, CF is 1 / (MX * MY), choose_probable_position(P, X, Y, CF, OBJ, TEAM). %guarantee out of bounds (valid position), scale back when calculating ranges
choose_probable_position(P, X, Y, CF, OBJ, TEAM) :- generate_possible_positions(P, X, Y, CF, OBJ, TEAM).

generate_possible_positions(P, X, Y, CF, OBJ, TEAM) :- map(W, H), RANGEX is round((1 - CF) * W), RANGEY is round((1 - CF) * H), generate_possible_positions(P, X, Y, RANGEX, RANGEY, OBJ, TEAM).

generate_possible_positions(P, X, Y, 0, 0, _, _) :-  assert(possible_position(P, X, Y, 1.0)). %if CF too large, default to actual estimated position
generate_possible_positions(P, X, Y, RANGEX, RANGEY, OBJ, TEAM) :- DX is X - RANGEX, DY is Y - RANGEY, SX is X + RANGEX, SY is Y + RANGEY, 
map_bound_x(LX, DX), map_bound_y(LY, DY), map_bound_x(UX, SX), map_bound_y(UY, SY), 
(generate_possible_positions(P, LX, LY, LX, UX, UY, OBJ, TEAM) ; true).

generate_possible_positions(P, UX, Y, LX, UX, UY, OBJ, TEAM) :- Y < UY, NY is Y + 1, generate_possible_positions(P, LX, NY, LX, UX, UY, OBJ, TEAM).
generate_possible_positions(P, X, Y, LX, UX, UY, OBJ, TEAM) :- X < UX, NX is X + 1, generate_possible_position(P, X, Y, OBJ, TEAM), generate_possible_positions(P, NX, Y, LX, UX, UY, OBJ, TEAM), !.

generate_possible_position(P, X, Y, OBJ, TEAM) :- (visibly_unoccupied(X, Y, TEAM), !, position_value(POSVAL, P, X, Y, OBJ, TEAM), choose_better_position(P, X, Y, POSVAL)) ; true.
choose_better_position(P, X, Y, V) :- (probable_position(P, _, _, V2), !, swap_best_position(P, X, Y, V, V2)) ; assert(probable_position(P, X, Y, V)).
swap_best_position(P, X, Y, V, V2) :- (V > V2, retractall(probable_position(P, _, _, _)), assert(probable_position(P, X, Y, V))) ; true.

position_value(VAL, P, X, Y, OBJ, TEAM) :- calculate_threat_level(TL, X, Y, TEAM), calculate_confidence_level(CL, P, X, Y, TEAM), calculate_objective_level(OL, OBJ, X, Y), VAL is (CL/(CL + TL)) * OL. %confidence ratio * objective ratio

/*
****************************************************
*	Calculate Confidence / Threat / Objective Levels
*		- Threat is calculated from the sum of enemy unit ratings/distance from a position (assumes all enemy positions known)
*		- Confidence is calculated from the sum of allied unit ratings/distance from a position, scaling the estimate by what is known (either visible or some estimated position)
*		- Objective is calculated as the value of the objective/distance from a position
****************************************************
*/

calculate_threat_level(TL, X, Y, TEAM) :- findall(E, team(E, TEAM), Enemies), calculate_threat_level(TL, 0, X, Y, Enemies).
calculate_threat_level(TL, L, _, _, []) :- TL is L.
calculate_threat_level(TL, L, X, Y, [H|T]) :- unit_rating(R, H), distance(D, H, X, Y), LL is (R / D) + L, calculate_threat_level(TL, LL, X, Y, T).

calculate_confidence_level(CL, P, X, Y, TEAM) :- team(P, T), findall(A, (team(A, T), A \= P), Allies), calculate_confidence_level(CL, 0, X, Y, Allies, TEAM), !.
calculate_confidence_level(CL, L, _, _, [], _) :- CL is L.
calculate_confidence_level(CL, L, X, Y, [H|T], TEAM) :- confidence_by_vision(LL, H, X, Y, TEAM), LLL is LL + L, calculate_confidence_level(CL, LLL, X, Y, T, TEAM).

confidence_by_vision(CL, Ally, X, Y, TEAM) :- unit_rating(R, Ally), (
(((visible(Ally, TEAM), distance(D, Ally, X, Y)) ; (probable_position(Ally, AX, AY, _), distance(D, AX, AY, X, Y))), CL is (R/(D+1))) ; %if visible or already have probable position, use it
((estimated_position(Ally, AX, AY, ACF) ; (last_seen(Ally, AX, AY, _, _), last_seen_cf(ACF, Ally))), distance(D, AX, AY, X, Y), CL is (ACF * R / (D+1))) ; %if estimated, or seen before, bias with CF
(CL is R / 2)). %arbitrary if no previous information

calculate_objective_level(OL, OBJ, X, Y) :- objective(OBJ, OBJVAL), position(OBJ, OX, OY), distance(D, OX, OY, X, Y), OL is OBJVAL / D.

/*
****************************************************
*	Unit Rating
*		- Unit rating is the sum of a player rating and a hero rating
*		- Player rating is a weighted value combining various statistics (Wins, Losses, Kills, Deaths, etc.)
*		- Hero rating is based on its scale factor, which scales with time, carry values exponentially increase while support values exponentially decay
****************************************************
*/

unit_rating(R, P) :- player_rating(PR, P), player(P, H), hero_rating(HR, H), R is PR + HR.

player_rating(PR, P) :- player_stats(P, W, L, MMR), weight(win_loss, W_WL), weight(mmr, W_MMR), PS is (W_WL * ((W+1)/(L+1))) + (W_MMR * MMR), 
player_game_stats(P, K, D, A), kda_value(KDA, K, D, A), PGS is KDA, 
PR is PS + PGS.

kda_value(KDA, K, D, A) :- weight(kills, W_K), weight(deaths, W_D), weight(assists, W_A), KDA is (W_K * K) + (W_D * D) + (W_A * A).

hero_rating(HR, H) :- hero_scale(HR, H).

hero_scale(S, H) :- hero_stats(H, CARRY, SUPPORT), time(M, _), S is ((1.2 ** M) * CARRY) + ((0.8 ** M) * (SUPPORT * 100)). %carries start out weak, but exponentially scale later, supports start out buffed, but decay over time

/*
****************************************************
*	Objective Value
*		- To determine objective value, first estimate probable positions for missing players, then calculate the value based on those estimates
*		- Confidence and Threat calculations very similar to before, except they include objective difficulty
****************************************************
*/

objective_value(V, TEAM, OBJ) :- determine_probable_positions(TEAM, OBJ), calculate_objective_value(V, TEAM, OBJ), retractall(probable_position(_, _, _, _)), !.

determine_probable_positions(TEAM, OBJ) :- missing(P, TEAM), choose_probable_position(P, OBJ, TEAM).

calculate_objective_value(V, TEAM, OBJ) :- objective(OBJ, VAL), confidence_level(CL, TEAM, OBJ), V is VAL * CL.

confidence_level(CL, TEAM, OBJ) :- findall(P, (not_on_team(P, TEAM)), Enemies), findall(P2, team(P2, TEAM), Allies), calculate_obj_threat(T, 0, Enemies, OBJ, TEAM), calculate_obj_confidence(C, 0, Allies, OBJ, TEAM), !, CL is C / (C + T).

calculate_obj_threat(Threat, T, [], _, _) :- Threat is T.
calculate_obj_threat(Threat, T, [P|L], OBJ, TEAM) :- position(OBJ, OX, OY), ((visible(P, TEAM), position(P, X, Y)) ; probable_position(P, X, Y, _)), 
unit_rating(R, P), objective_difficulty(OBJ, P, OD), distance(D, X, Y, OX, OY), 
TT is T + (R / D) / OD, calculate_obj_threat(Threat, TT, L, OBJ, TEAM).

calculate_obj_confidence(Confidence, C, [], _, _) :- Confidence is C.
calculate_obj_confidence(Confidence, C, [P|L], OBJ, TEAM) :- position(OBJ, OX, OY), position(P, X, Y), 
unit_rating(R, P), distance(D, X, Y, OX, OY), objective_difficulty(OBJ, P, OD),
CC is C + (R / D) / OD, calculate_obj_confidence(Confidence, CC, L, OBJ, TEAM).

/*
****************************************************
*	Determine Objective
*		- Generate values for each objective
*		- Select and return the optimal (highest valued) objective
****************************************************
*/

determine_objective(OBJ, TEAM) :- determine_objective(TEAM), optimal_objective(OBJ, TEAM), retract(optimal_objective(_, TEAM)).

determine_objective(TEAM) :- findall(O, objective(O, _), Objectives), determine_objective(_, 0, TEAM, Objectives).
determine_objective(O, _, TEAM, []) :- assert(optimal_objective(O, TEAM)).
determine_objective(O, V, TEAM, [H|T]) :- objective_value(NV, TEAM, H),
((NV > V, determine_objective(H, NV, TEAM, T)) ; determine_objective(O, V, TEAM, T)), !.

/*
****************************************************
*	Print Map
*		- Print out the map state in ASCII
*		- Supports spectator (all vision) and team (team vision) formats
****************************************************
*/

print_map :- map(C, R), print_spaces(0), print_indices(C), nl, print_indice(0), print_map(0, 0, C, R).
print_map(C, Ri, C, R) :- Ri < R, nl, RI is Ri + 1, print_indice(RI), print_map(0, RI, C, R).
print_map(Ci, Ri, C, R) :- Ci < C, print_pos(Ci, Ri), CI is Ci + 1, print_map(CI, Ri, C, R).

print_pos(X, Y) :- get_print_label(L, X, Y), write(L), write_length(L, LEN, []), print_spaces(LEN).
get_print_label(L, X, Y) :- ((position(Z, X, Y), L = Z) ; (not(position(_, X, Y)), L = "X")).

print_indices(C) :- print_indices(0, C) ; true.
print_indices(I, C) :- I < C, II is I + 1, print_indice(I), print_indices(II, C).

print_indice(I) :- write(I), write_length(I, LEN, []), print_spaces(LEN).

print_spaces(L) :- print_line_len(LEN), Spaces is LEN - L, not(p_spaces(0, Spaces)).
p_spaces(I, S) :- I < (S + 1), write(" "), II is I + 1, p_spaces(II, S).

print_map(TEAM) :- map(C, R), print_spaces(0), print_indices(C), nl, print_indice(0), print_map(0, 0, C, R, TEAM).
print_map(C, Ri, C, R, TEAM) :- nl, Ri < R, RI is Ri + 1, print_indice(RI), print_map(0, RI, C, R, TEAM).
print_map(Ci, Ri, C, R, TEAM) :- Ci < C, print_pos(Ci, Ri, TEAM), CI is Ci + 1, print_map(CI, Ri, C, R, TEAM).

print_pos(X, Y, TEAM) :- get_print_label(L, X, Y, TEAM), write(L), write_length(L, LEN, []), print_spaces(LEN).

get_print_label(L, X, Y, TEAM) :- 
(((position(Z, X, Y), player(Z, _), visible(Z, TEAM), !) ; (position(Z, X, Y), not(player(Z, _)), !)), L = Z) ;
(estimated_position(P, X, Y, _), !, string_concat(P, "*", L)) ;
(visible_position(X, Y, TEAM), !, L = "-") ; 
L = "X".

/*
****************************************************
*	Input Logic
*		- Get Estimates handles processing user input when they provide an estimated position
*		- Print Board State displays relevant game information
****************************************************
*/

get_estimates(_, []).
get_estimates(TEAM, [H|T]) :- (get_estimate(TEAM, H), get_estimates(TEAM, T)) ; 
(nl, y_n("Try Again?"), append([H], T, L), get_estimates(TEAM, L)) ;
(get_estimates(TEAM, T)).

get_estimate(TEAM, P) :- (display_last_seen(P) ; true), write("Enter an estimated X position for "), write(P), write(": "), read(X),
write("Enter an estimated Y position for "), write(P), write(": "), read(Y),
write("Enter how certain you think "), write(P), write(" is at ["), write(X), write(", "), write(Y), write("] (0 - 1): "), read(CF), nl,
verify_estimate(X, Y, CF),
((valid_estimated_position(TEAM, X, Y), assert(estimated_position(P, X, Y, CF))) ; 
(write("Sorry, "), write(P), write(" could not be at that position with this board state."), nl, nl, fail)).

verify_estimate(X, Y, CF) :- ((CF > 0, CF < 1) ; (write("Invalid CF."), nl, fail)), !,
map(W, H), WW is W + 1, HH is H + 1, 
((X > -1, X < WW) ; (write("X Out of Bounds."), nl, fail)), !,
((Y > -1, Y < HH) ; (write("Y Out of Bounds."), nl, fail)), !.

valid_estimated_position(TEAM, X, Y) :- not(estimated_position(_, X, Y, _)), visibly_unoccupied(X, Y, TEAM).

display_last_seen(P) :- last_seen(P, X, Y, M, S), difference_from_current_time(T, 0, M, S), 
write("Opponent "), write(P), write(" was last seen "), write(T), write(" seconds ago at ["), write(X), write(", "), write(Y), write("]."), nl.

print_board_state :- map(W, H), findall(O, objective(O, _), Objectives), findall(T, team(_, T), Teams), list_to_set(Teams, T),
write("You are on a "), write(W), write("x"), write(H), write(" board. There are several objectives and teams."), nl,
write("Objectives: "), write(Objectives), nl, nl,
print_teams(T), nl,
time(M, S), write("The current game time is: "), write(M), write(":"), write(S), write("."), nl.

print_teams([]).
print_teams([H|T]) :- write("Team "), write(H), write(": "), findall(P, team(P, H), Players), write(Players), nl, print_teams(T).

clr_ests :- retractall(estimated_position(_, _, _, _)).

/*
****************************************************
*	Run
*		- User input driven command line interface
*		- Enter a team, optionally enter estimated positions for missing enemies, and get back an objective to pursue
****************************************************
*/

run :- write("Welcome to Objective Chooser 1.0!"), nl,
write("This expert system will choose an objective for your team to pursue."), nl, nl,
print_board_state, nl, nl,
write("Please enter your team name: "), read(TEAM), team(_, TEAM), !, nl,
(print_map(TEAM) ; true), nl,
((findall(P, (not(estimated_position(P, _, _, _)), missing(P, TEAM)), Missing), trim_last_list_element(Missing, M), M \= [], y_n("We noticed some players are missing, could you estimate where they are?"), nl, get_estimates(TEAM, M)) ; true),
((estimated_position(_, _, _, _), !, nl, (print_map(TEAM) ; true), nl) ; true),
determine_objective(OBJ, TEAM), nl,
write("Based on the state of the board, you should attempt the '"), write(OBJ), write("' objective."),
clr_ests.

%--------CONSTANTS--------

max_visibility_distance(5).
last_seen_decay_factor(0.9).
print_line_len(8).

weight(win_loss, 0.6).
weight(mmr, 0.4).
weight(kills, 0.4).
weight(deaths, 0.3).
weight(assists, 0.3).