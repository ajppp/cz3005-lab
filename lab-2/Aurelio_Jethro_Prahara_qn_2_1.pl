male('prince charles').
male('prince andrew').
male('prince edward').

female('princess ann').

offspring('prince charles', 'queen elizabeth').
offspring('princess ann', 'queen elizabeth').
offspring('prince andrew', 'queen elizabeth').
offspring('prince edward', 'queen elizabeth').

successor(X, Y) :- successor_male(Y, X); successor_female(Y, X).

successor_male(X, Y) :- offspring(X, Y), 
male(X).

successor_female(X, Y) :- offspring(X, Y), 
female(X).
