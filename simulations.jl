using StatsBase


const ϵ = .1
moves = [[i j] for i in -1:1 for j in -1:1]
splice!(moves, 5)


choose_voters(N::Int, q::Int, position::Array{Int, 2}, replace::Bool)::Array{Array{Int, 2}, 1} =
        [mod.(position + move .- 1, N) .+ 1 for move in sample(moves, q, replace = replace)]


function decide(network::BitArray{2}, q::Int, position::Array{Int, 2}, replace::Bool)::Int8
        decisive = network[position...]
        voters = choose_voters(size(network)[1], q, position, replace)
        votes = sum([network[voters[i]...] for i in 1:q])
        return votes == q ? 1 : votes == 0 ? 0 : mod(decisive + rand() < ϵ, 2)
end


function change(network::BitArray{2}, q::Int, replace::Bool)::Int8
        position = rand(1:size(network)[1], 1, 2)
        network[position...] = decide(network, q, position, replace)
end
