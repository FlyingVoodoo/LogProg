% =========================================================
% 1. ПОДКЛЮЧЕНИЕ ФАКТОВ ИЗ ОТДЕЛЬНОГО ФАЙЛА
% =========================================================
:- consult('grades.pl').

% =========================================================
% 2. ВСПОМОГАТЕЛЬНЫЕ ПРЕДИКАТЫ
% =========================================================
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).
sum_list([], 0).
sum_list([H|T], Sum) :- sum_list(T, Sum1), Sum is H + Sum1.
max_list([M], M).
max_list([H|T], M) :- max_list(T, MT), (H > MT -> M = H ; M = MT).

get_all_students(Students) :-
    setof(Student, Group^group(Group, List)^(my_member(Student, List)), Students).

student_group(Student, Group) :-
    group(Group, Students),
    my_member(Student, Students).

student_all_grades(Student, Grade) :-
    subject(_, GradesList),
    my_member(grade(Student, Grade), GradesList).

average_grade(Student, Avg, Status) :-
    findall(Grade, student_all_grades(Student, Grade), Grades),
    length(Grades, Count),
    (my_member(2, Grades) -> Status = failed ; Status = passed),
    Count > 0,
    sum_list(Grades, Sum),
    Avg is Sum / Count.

% =========================================================
% 3. ЗАДАНИЯ ПО ВАРИАНТУ 3
% =========================================================

report_student_avg :-
    write('Средний балл и статус каждого студента:'), nl, nl,
    get_all_students(Students),
    calculate_avg_for_students(Students).

calculate_avg_for_students([]).
calculate_avg_for_students([Student|Rest]) :-
    average_grade(Student, Avg, Status),
    format('~w: Ср. балл: ~2f, Статус: ~w', [Student, Avg, Status]), nl,
    calculate_avg_for_students(Rest).

get_all_subjects(Subjects) :-
    setof(Subject, GradesList^grade(_, _)^(subject(Subject, GradesList)), Subjects).

failed_students_per_subject :-
    write('Количество не сдавших студентов по предметам:'), nl, nl,
    get_all_subjects(Subjects),
    count_failed_per_subject(Subjects).

count_failed_per_subject([]).
count_failed_per_subject([Subject|Rest]) :-
    setof(Student, Grade^(subject(Subject, GradesList), my_member(grade(Student, Grade), GradesList), Grade < 3), FailedStudents),
    !,
    length(FailedStudents, Count),
    format('~w: ~w студентов', [Subject, Count]), nl,
    count_failed_per_subject(Rest).
count_failed_per_subject([_|Rest]) :-
    count_failed_per_subject(Rest).


get_all_groups(Groups) :-
    setof(Group, Students^group(Group, Students), Groups).

student_group_avg(Student, Group, Avg) :-
    student_group(Student, Group),
    average_grade(Student, Avg, _).

find_max_avg_in_group(Group, MaxAvg) :-
    findall(Avg, student_group_avg(_, Group, Avg), Avgs),
    Avgs = [_|_], 
    max_list(Avgs, MaxAvg).

report_top_students_by_group :-
    write('Студент(ы) с максимальным средним баллом по группам:'), nl, nl,
    get_all_groups(Groups),
    calculate_top_per_group(Groups).

calculate_top_per_group([]).
calculate_top_per_group([Group|Rest]) :-
    find_max_avg_in_group(Group, MaxAvg),
    findall(S, student_group_avg(S, Group, MaxAvg), TopStudents),
    format('Группа ~w: Макс. ср. балл: ~2f, Лучшие студенты: ~w', [Group, MaxAvg, TopStudents]), nl,
    calculate_top_per_group(Rest).

main :-
    nl, report_student_avg, nl, nl,
    failed_students_per_subject, nl, nl,
    report_top_students_by_group, nl.