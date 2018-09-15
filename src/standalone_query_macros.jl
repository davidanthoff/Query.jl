function template_args(args)
    escaped_args = esc.(helper_replace_anon_func_syntax.(args))
    zip(escaped_args, quot.(escaped_args)) |> flatten
end

function standalone_template(afunction, source, args)
    :(QueryOperators.$afunction(QueryOperators.query($(esc(source))), $(template_args(args)...))) |>
        helper_namedtuples_replacement
end

function standalone_template(afunction, source1, source2, args)
    :(QueryOperators.$afunction(QueryOperators.query($(esc(source1))), QueryOperators.query($(esc(source2))), $(template_args(args)...))) |>
        helper_namedtuples_replacement
end

function anonymous_template(afunction, args)
    :(i -> QueryOperators.$afunction(QueryOperators.query(i), $(template_args(args)...))) |>
        helper_namedtuples_replacement
end

function anonymous_template(afunction, source2, args)
    :(i -> QueryOperators.$afunction(QueryOperators.query(i), QueryOperators.query($(esc(source2))), $(template_args(args)...))) |>
        helper_namedtuples_replacement
end

macro count(source, f)
    standalone_template(:count, source, (f,))
end

macro count(source)
    standalone_template(:count, source, ())
end

macro count()
    standalone_template(:count, ())
end

macro groupby(source, elementSelector, resultSelector)
    standalone_template(:groupby, source, (elementSelector, resultSelector))
end

macro groupby(elementSelector, resultSelector)
    anonymous_template(:groupby, (elementSelector, resultSelector))
end

macro groupby(elementSelector)
    anonymous_template(:groupby, (elementSelector, :(i -> i)))
end

macro groupjoin(outer, inner, outerKeySelector, innerKeySelector, resultSelector)
    standalone_template(:groupjoin, outer, inner, (outerKeySelector, innerKeySelector, resultSelector))
end

macro groupjoin(inner, outerKeySelector, innerKeySelector, resultSelector)
    anonymous_template(:groupjoin, inner, (outerKeySelector, innerKeySelector, resultSelector))
end

macro join(outer, inner, outerKeySelector, innerKeySelector, resultSelector)
    standalone_template(:join, outer, inner, (outerKeySelector, innerKeySelector, resultSelector))
end

macro join(inner, outerKeySelector, innerKeySelector, resultSelector)
    anonymous_template(:join, inner, (outerKeySelector, innerKeySelector, resultSelector))
end

macro orderby(source, f)
    standalone_template(:orderby, source, (f,))
end

macro orderby(f)
    anonymous_template(:orderby, (f,))
end

macro orderby_descending(source, f)
    standalone_template(:orderby_descending, source, (f,))
end

macro orderby_descending(f)
    anonymous_template(:orderby_descending, (f,))
end

macro thenby(source, f)
    standalone_template(:thenby, source, (f,))
end

macro thenby(f)
    anonymous_template(:thenby, (f,))
end

macro thenby_descending(source, f)
    standalone_template(:thenby, source, (f,))
end

macro thenby_descending(f)
    anonymous_template(:thenby_descending, (f,))
end

macro map(source, f)
    standalone_template(:map, source, (f,))
end

macro map(f)
    anonymous_template(:map, (f,))
end

macro mapmany(source, collectionSelector,resultSelector)
    standalone_template(:mapmany, source, (collectionSelector, resultSelector))
end

macro mapmany(collectionSelector,resultSelector)
    anonymous_template(:mapmany, source, (collectionSelector, resultSelector))
end

macro filter(source, f)
    standalone_template(:filter, source, (f,))
end

macro filter(f)
    standalone_template(:filter, (f,))
end

macro take(source, n)
    return :(QueryOperators.take(QueryOperators.query($(esc(source))), $(esc(n))))
end

macro take(n)
    return :( i -> QueryOperators.take(QueryOperators.query(i), $(esc(n))))
end

macro drop(source, n)
    return :(QueryOperators.drop(QueryOperators.query($(esc(source))), $(esc(n))))
end

macro drop(n)
    return :( i -> QueryOperators.drop(QueryOperators.query(i), $(esc(n))))
end
