using StatsBase


const ϵ = .1
moves = [[i j] for i in -1:1 for j in -1:1]
splice!(moves, 5)


choose_voters(N::Int, q::Int, position::Array{Int, 2}, replace::Bool)::Array{Array{Int, 2}, 1} =
        [mod.(position + move .- 1, N) .+ 1 for move in sample(moves, q, replace = replace)]


function get_votes(network::BitArray{2}, q::Int, position::Array{Int, 2},
                   replace::Bool)::Tuple
        decisive = network[position...]
        voters = choose_voters(size(network)[1], q, position, replace)
        return sum([network[voters[i]...] for i in 1:q]), decisive
end


function conformity(network::BitArray{2}, q::Int, position::Array{Int, 2},
                    replace::Bool)::Int8
        votes, decisive = get_votes(network, q, position, replace)
        return votes == q ? 1 : votes == 0 ? 0 : decisive
end


function anticonformity(network::BitArray{2}, q::Int, position::Array{Int, 2},
                        replace::Bool)::Int8
        votes, decisive = get_votes(network, q, position, replace)
        votes == q ? 0 : votes == 0 ? 1 : decisive
end


function independence(network::BitArray{2}, f::Float64, position::Array{Int, 2})::Int8
        U = rand()
        decisive = network[position...]
        return U < f ? mod(decisive + 1, 2) : decisive
end


function change(network::BitArray{2}, q::Int, p::Float64, f::Float64,
                independent::Bool, replace::Bool)::Int8
        position = rand(1:size(network)[1], 1, 2)
        network[position...] = rand() < 1 - p ? conformity(network, q, position, replace) :
                               independent ? independence(network, f, position) :
                               anticonformity(network, q, position, replace)
end
