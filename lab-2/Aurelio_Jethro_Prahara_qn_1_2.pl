company(sumsum).
company(appy).

competitor(sumsum, appy).

technology(galactica-s3).


develop(sumsum, galactica-s3).

stolen(galactica-s3, stevey).

boss(stevey, appy).

business(X) :- technology(X).

rival(X, appy) :- company(X),
    competitor(X, appy).

unethical(X) :- boss(X, Y),
stolen(Z, X),
business(Z),
develop(C, Z),
rival(C, Y).

