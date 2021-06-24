using StatsBase
export change


const ϵ = .1
moves = [[i j] for i in -1:1 for j in -1:1]
splice!(moves, 5)


choose_voters(N::Int, q::Int, position::Array{Int, 2}, replaced::Bool)::Array{Array{Int, 2}, 1} =
        [mod.(position + move .- 1, N) .+ 1 for move in sample(moves, q, replace = replaced)]


function get_votes(network::AbstractArray, q::Int, position::Array{Int, 2},
                   replaced::Bool)::Tuple
        decisive = network[position...]
        voters = choose_voters(size(network)[1], q, position, replaced)
        return sum([network[voters[i]...] for i in 1:q]), decisive
end


function conformity(network::AbstractArray, q::Int, position::Array{Int, 2},
                    replaced::Bool)::Int8
        votes, decisive = get_votes(network, q, position, replaced)
        return votes == q ? 1 : votes == 0 ? 0 : decisive
end


function anticonformity(network::AbstractArray, q::Int, position::Array{Int, 2},
                        replaced::Bool)::Int8
        votes, decisive = get_votes(network, q, position, replaced)
        votes == q ? 0 : votes == 0 ? 1 : decisive
end


function independence(network::AbstractArray, f::Float64, position::Array{Int, 2})::Int8
        U = rand()
        decisive = network[position...]
        return U < f ? mod(decisive + 1, 2) : decisive
end


function change(network::AbstractArray, q::Int, p::Float64, f::Float64,
                independent::Bool, replaced::Bool)::Int8
        position = rand(1:size(network)[1], 1, 2)
        network[position...] = rand() < 1 - p ? conformity(network, q, position, replaced) :
                               independent ? independence(network, f, position) :
                               anticonformity(network, q, position, replaced)
end
