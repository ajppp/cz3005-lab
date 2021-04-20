offspring('prince charles', 'queen elizabeth').
offspring('princess ann', 'queen elizabeth').
offspring('prince andrew', 'queen elizabeth').
offspring('prince edward', 'queen elizabeth').

successor(X, Y) :- offspring(Y, X).
