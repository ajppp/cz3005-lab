/*
 *function that is first ran when running the program
 *start by asking if they want the combo option
 */ 

ask(0):-
    write("Hi! Welcome to Subway. Would you be interested in a "),
    validate_and_query_options([normal]).

/*
 *function to ask a user when it is not their first time
 */

ask(Y):-

    generate_options(Y, L),
    validate_and_query_options(L).

/*
 *if the user has ordered a meal, a bread or a meat
 *ask them for something from the next category
 */

generate_options(Y, L):-

    order(Y),
    meals(H), 
    member(Y, H),
    add_to_restrictions(Y),
    write("For your bread, would you want " ),
    findall(X, next_category(Y, X), L).

/*
 * If the user orders the vegan or veggie meal, skip the meat
 * and ask them what veggies they want
 */


 generate_options(Y, L):-
     order(Y),
     breads(K), 
     member(Y, K),
     write("Would you want " ),
     findall(X, next_category(Y, X), L).
 
/*
 * If the user has ordered a meat, ask them for what veggies they want
 */

generate_options(Y, L):-

    order(Y),
    meats(M), 
    member(Y, M), 
    write("From the next category, would you want " ),
    findall(X, next_category(Y, X), L).

/*
 * If the user ordered a drink or is not interested, the program stops
 */

generate_options(Y, L):-

    (order(Y); change(Y)),
    drinks(D),
    member(Y, D),
    write("Thanks for visiting Subway!, your order consists of "),
    findall(X, order(X), A),
    write(A),
    write(" . Hope to see you again soon! Your order will be ready in 10 minutes"),
    halt.


/*
 * If the user said no to tea, the program stops since there are no more options
 */

generate_options(Y, L):-
    Y = tea,
    print("Thanks for visiting Subway!, your order consists of "),
    findall(X, order(X), A),
    write(A),
    write(" . Hope to see you again soon! Your order will be ready in 10 minutes"),
    halt.

/*
 *generic option said when someone presses X and changes to the next category
 */
    
generate_options(Y, L) :-
    change(Y),
    write("From the next category, would you want " ),
    findall(X, next_category(Y, X), L).

/*
 *if the user likes the current option then 
 *ask for something from the same category
 */

generate_options(Y, L) :-
    order(Y),
    write("Do you also want " ),
    findall(X, same_category(Y, X), L).

/*
 *else if the current option is not liked
 *ask from a different category?
 */

generate_options(Y, L) :-

    unwanted(Y),
    write("Okay, would you be interested in " ),
    findall(X, same_category(X, Y), L).

/*
 *find the list of items but if it empty, find an option
 *from the next category and ask the user if they want it
 */

validate_and_query_options(L):-

    /*
     *find all of the items that the customer ordered
     *and the items that he doesn't want and 
     *put it into a list called Orderlist and
     *Unwantedlist
     */

	findall(X, order(X), Orderlist),
    findall(X, unwanted(X), Unwantedlist),

    /*
     * append the ordered list and unwanted list
     * into a list called History
     */

    append(Orderlist,Unwantedlist, History),

    /*
     *convert the input list into a set S
     *convert History into a set H
     */

    list_to_set(L,S), 
    list_to_set(History,H),

    /*
     *substract the member of H from the set S
     *this becomes the set Valid
     */

    subtract(S,H,Valid),

    /*
     *if the set Valid is empty, that means every option from
     *this category is in the order list or in the unwanted list,
     *get the item from the order list and ask for an item
     *from the next category
     */

    length(Valid, 0),
    /*
     * we have run out of items for this category
     */

    memberchk(A, L),
    findall(B, next_category(A, B), C),
    validate_and_query_options(C).


/*
 * L is the list of item that is in the category
 * of items that should be asked to a user
 */

validate_and_query_options(L):-

    /*
     *find all of the items that the customer ordered
     *and the items that he doesn't want and 
     *put it into a list called Orderlist and
     *Unwantedlist
     */

	findall(X, order(X), Orderlist),
    findall(X, unwanted(X), Unwantedlist),

    /*
     * append the ordered list and unwanted list
     * into a list called History
     */

    append(Orderlist,Unwantedlist, History),

    /*
     *convert the input list into a set S
     *convert History into a set H
     */

    list_to_set(L,S), 
    list_to_set(History,H),

    /*
     *substract the member of H from the set S
     *this becomes the set Valid
     */

    subtract(S,H,Valid),

    /*
     *check if X is a member of Valid
     */

    member(X, Valid),
    check_member(X),
    print(X),
    print("? y/n/x/q:" ),

    read(Like),
    (Like==q -> abort; Like==y -> assert(order(X)); Like==x -> assert(change(X)); assert(unwanted(X))), 
    ask(X).


/*
 *options for the subway meal
 */

meals([value, healthy, vegan, veggie, normal]).
breads([parmesan, wheat,  italian, honey_wheat, hearty_italian, flatbread]).
meats([chicken, turkey, beef, ham, salmon, bacon, tuna ]).
veggies([lettuce, green_peppers, tomatoes, olives, red_onions, avocado, guacamole, cucumber]).
fatty_sauces([bbq, chipotle, sweet_chilli, vinaigrette, mayonnaise, ranch]).
non_fatty_sauces([sweet_onion, honey_mustard, vinegar]).
cheese_topups([american, brie, monterey_cheddar]).
non_cheese_topups([egg_mayo, avocado_topup]).
sides([chips, cookies, hashbrowns]).
drinks([water, sunkist, ice_lemon_tea, coffee, tea]).

/*
 *returns the same category.
 */

same_category(X,Y):-
    meals(L), member(X, L), member(Y, L);
    breads(L), member(X, L), member(Y, L);
    meats(L), member(X, L), member(Y, L);
    veggies(L), member(X, L), member(Y, L);
    fatty_sauces(L), member(X, L), member(Y, L);
    non_fatty_sauces(L), member(X, L), member(Y, L);
    cheese_topups(L), member(X, L), member(Y, L);
    non_cheese_topups(L), member(X, L), member(Y, L);
    sides(L), member(X, L), member(Y, L);
    drinks(L), member(X, L), member(Y, L).


/*
 *get the next category that the bot should ask for after
 *they are done with the current category e.g.
 *after having one bread, they should ask for meat
 */

next_category(X, Y):-

    meals(L), member(X, L), breads(K), member(Y, K);
    breads(L), member(X, L), meats(K), member(Y, K);
    meats(L), member(X, L), veggies(K), member(Y, K);
    veggies(L), member(X, L), fatty_sauces(K), member(Y, K);
    fatty_sauces(L), member(X, L), non_fatty_sauces(K), member(Y, K);
    non_fatty_sauces(L), member(X, L), cheese_topups(K), member(Y, K);
    cheese_topups(L), member(X, L), non_cheese_topups(K), member(Y, K);
    non_cheese_topups(L), member(X, L), sides(K), member(Y, K);
    sides(L), member(X, L), drinks(K), member(Y, K).

/*
 *add the item that they cannot have to their unwanted.
 *This prevents the query from asking the user if they want it.
 */

add_to_restrictions(X) :-

    value = X,
    findall(A, same_category(brie, A), L),
    findall(B, same_category(egg_mayo, B), M),
    findall(D, same_category(hashbrowns, D), N),
    append(L, M, O),
    append(O, N, Q),
    list_to_set(Q, UnwantedSet),
    forall(member(C, UnwantedSet), assert(unwanted(C)));

    healthy = X,
    findall(A, same_category(chipotle, A), L),
    findall(B, same_category(hashbrowns, B), M),
    append(L, M, O),
    list_to_set(O, UnwantedSet),
    forall(member(C, UnwantedSet), assert(unwanted(C)));

    vegan = X,
    findall(A, same_category(chicken, A), L),
    findall(B, same_category(brie, B), M),
    append(L, M, O),
    list_to_set(O, UnwantedSet),
    forall(member(C, UnwantedSet), assert(unwanted(C)));

    veggie = X,
    findall(A, same_category(chicken, A), L),
    list_to_set(L, UnwantedSet),
    forall(member(C, UnwantedSet), assert(unwanted(C)));

    normal = X.

:- dynamic order/1, unwanted/1, change/1.

order(sub).
unwanted(nothing).
change(nothing).
a.
