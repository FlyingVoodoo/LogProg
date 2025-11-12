check_builtin_predicates :-
    write('Проверка встроенных предикатов:'), nl,
    (length([1,2,3], L) -> write('length доступен, L='), write(L), nl ; write('length недоступен'), nl),
    (member(2, [1,2,3]) -> write('member доступен'), nl ; write('member недоступен'), nl),
    (append([1,2], [3,4], X) -> write('append доступен, X='), write(X), nl ; write('append недоступен'), nl).

% ======================================
% 1. Ваши версии стандартных предикатов
% ======================================
my_length([], 0).
my_length([_|T], N) :- my_length(T, N1), N is N1 + 1.

my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

my_append([], L, L).
my_append([H|T], L, [H|R]) :- my_append(T, L, R).

my_remove(X, [X|T], T).
my_remove(X, [H|T], [H|R]) :- my_remove(X, T, R).

my_permute([], []).
my_permute(L, [X|P]) :- my_remove(X, L, R), my_permute(R, P).

my_sublist(S, L) :- my_append(_, T, L), my_append(S, _, T).

% ======================================
% 2. Предикат 1.1: Удаление всех элементов (Вар. 12)
% ======================================

% Способ 1: Рекурсия (без стандартных)
remove_all_manual(_, [], []).
remove_all_manual(X, [X|T], R) :-
    !,
    remove_all_manual(X, T, R).
remove_all_manual(X, [H|T], [H|R]) :-
    X \= H,
    remove_all_manual(X, T, R).

% Способ 2: Со стандартным (на основе my_member)
remove_all_std(X, ListIn, ListOut) :-
    findall(Elem, (my_member(Elem, ListIn), Elem \= X), ListOut).

% ======================================
% 3. Предикат 1.2: Слияние упорядоченных списков (Вар. 17)
% ======================================

% Способ 1: Рекурсия (без стандартных)
merge_sorted_manual([], L2, L2).
merge_sorted_manual(L1, [], L1).
merge_sorted_manual([H1|T1], [H2|T2], [H1|R]) :-
    H1 =< H2,
    merge_sorted_manual(T1, [H2|T2], R).
merge_sorted_manual([H1|T1], [H2|T2], [H2|R]) :-
    H2 < H1,
    merge_sorted_manual([H1|T1], T2, R).

% Способ 2: Со стандартным (my_append и msort)
merge_sorted_std(L1, L2, LMerged) :-
    my_append(L1, L2, LCombined),
    msort(LCombined, LMerged).

% ======================================
% 4. Совместное использование (Пункт 6)
% ======================================

check_merge_and_remove(L1, L2) :-
    write('Список 1: '), write(L1), nl,
    write('Список 2: '), write(L2), nl,
    L1 = [FirstElem|_],
    merge_sorted_manual(L1, L2, LMerged),
    write('Слитый список: '), write(LMerged), nl,
    remove_all_manual(FirstElem, LMerged, LFinal),
    format('Удаляем все вхождения элемента ~w: ', [FirstElem]), write(LFinal), nl, nl.


run_all_tests :-
    check_builtin_predicates, nl,
    
    write('=== ТЕСТИРОВАНИЕ СТАНДАРТНЫХ ПРЕДИКАТОВ (Ваши версии) ==='), nl, nl,
    my_length([a,b,c,d], L1), write('1. my_length: '), write(L1), nl,
    (my_member(b, [a,b,c]) -> write('2. my_member: да'), nl ; write('2. my_member: нет'), nl),
    my_append([1,2], [3,4], R1), write('3. my_append: '), write(R1), nl, nl,
    
    write('=== ТЕСТИРОВАНИЕ СПЕЦИАЛЬНЫХ ПРЕДИКАТОВ (Вариант 12 и 17) ==='), nl, nl,
    
    write('1. Удаление всех элементов (Вар. 12):'), nl,
    remove_all_manual(5, [1, 5, 2, 5, 3, 5], R2), write('manual([1,5,2,5,3,5], 5): '), write(R2), nl,
    remove_all_std(a, [a, b, a, c], R3), write('std([a,b,a,c], a): '), write(R3), nl, nl,
    
    write('2. Слияние упорядоченных списков (Вар. 17):'), nl,
    merge_sorted_manual([1, 4, 7], [2, 5, 9], R4), write('manual([1,4,7], [2,5,9]): '), write(R4), nl,
    merge_sorted_std([1, 5], [1, 3], R5), write('std([1,5], [1,3]): '), write(R5), nl, nl,
    
    write('=== ПРИМЕР СОВМЕСТНОГО ИСПОЛЬЗОВАНИЯ (Пункт 6) ==='), nl, nl,
    check_merge_and_remove([1, 5, 10], [1, 3, 8]),
    check_merge_and_remove([2, 2, 4], [1, 3]).