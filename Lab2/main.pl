solve :-
    Цвета = [belyi, zelenyi, sinii],

    permutation(Цвета, [Anya_P, Valya_P, Natasha_P]),
    permutation(Цвета, [Anya_T, Valya_T, Natasha_T]),

    Pairs = [ d(anya, Anya_P, Anya_T),
              d(valya, Valya_P, Valya_T),
              d(natasha, Natasha_P, Natasha_T) ],

    condition1(Pairs),
    condition2(Pairs),
    condition3(Pairs),

    format('Решение найдено:~n'),
    print_pairs(Pairs).

get_colors(Pairs, Person, P, T) :-
    member(d(Person, P, T), Pairs).

% Валя: Ни туфли, ни платье не были белыми.
condition1(Pairs) :-
    get_colors(Pairs, valya, Valya_P, Valya_T),
    Valya_P \= belyi,
    Valya_T \= belyi.

% Наташа: Была в зеленых туфлях.
condition2(Pairs) :-
    get_colors(Pairs, natasha, _, Natasha_T),
    Natasha_T = zelenyi.

% Общее: Не было сочетания зеленого и белого.
condition3(Pairs) :-
    forall(
        member(d(_, P, T), Pairs),
        (
            \+ (P = zelenyi, T = belyi),
            \+ (P = belyi, T = zelenyi)
        )
    ).

print_color(belyi) :- format('Белый').
print_color(zelenyi) :- format('Зеленый').
print_color(sinii) :- format('Синий').

print_name(anya) :- format('Аня').
print_name(valya) :- format('Валя').
print_name(natasha) :- format('Наташа').

print_pairs([]).
print_pairs([d(Person, P, T)|Pairs]) :-
    print_name(Person),
    format(': Платье - '), print_color(P),
    format(', Туфли - '), print_color(T),
    format('~n'),
    print_pairs(Pairs).