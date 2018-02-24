constructor_of(::T) where T = constructor_of(T)
constructor_of(T::Type) = getfield(T.name.module, Symbol(T.name.name))
constructor_of(T::UnionAll) = constructor_of(T.body)

"""
    recon(thing; <keyword arguments>)

Re-construct `thing` with new field values specified by the keyword
arguments.
"""
@generated function recon(thing; kwargs...)
    fields = [Expr(:kw, k, :(thing.$k)) for k in fieldnames(thing)]
    return quote
        constructor = $constructor_of(thing)
        constructor(; $(fields...), kwargs...)
    end
end
