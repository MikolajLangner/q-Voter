using StatsBase

moves = [[i j] for i in -1:1 for j in -1:1]
splice!(moves, 5)

choose_voters(q::Int, position::Array{Int, 2}, N::Int, replace::Bool) =
        voters = [mod.(position + move .- 1, N) .+ 1 for move in sample(moves, q, replace = replace)]
