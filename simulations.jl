using StatsBase, Random
export change, random, circlular, chess, stripes, ring


moves = [[i j] for i in -1:1 for j in -1:1]
splice!(moves, 5)


choose_voters(N::Int, q::Int, position::Array{Int, 2}, replacement::Bool)::Array{Array{Int, 2}, 1} =
        [mod.(position + move .- 1, N) .+ 1 for move in sample(moves, q, replace = replacement)]


function get_votes(network::AbstractArray, q::Int, position::Array{Int, 2},
                   replacement::Bool)::Tuple
        decisive = network[position...]
        voters = choose_voters(size(network)[1], q, position, replacement)
        return sum([network[voters[i]...] for i in 1:q]), decisive
end


function conformity(network::AbstractArray, q::Int, position::Array{Int, 2},
                    replacement::Bool)::Int8
        votes, decisive = get_votes(network, q, position, replacement)
        return votes == q ? 1 : votes == 0 ? 0 : decisive
end


function anticonformity(network::AbstractArray, q::Int, position::Array{Int, 2},
                        replacement::Bool)::Int8
        votes, decisive = get_votes(network, q, position, replacement)
        votes == q ? 0 : votes == 0 ? 1 : decisive
end


function independence(network::AbstractArray, f::Float64, position::Array{Int, 2})::Int8
        U = rand()
        decisive = network[position...]
        return U < f ? mod(decisive + 1, 2) : decisive
end


function change(network::AbstractArray, q::Int, p::Float64, f::Float64,
                independent::Bool, replacement::Bool)::Int8
        position = rand(1:size(network)[1], 1, 2)
        network[position...] = rand() < 1 - p ? conformity(network, q, position, replacement) :
                               independent ? independence(network, f, position) :
                               anticonformity(network, q, position, replacement)
end


random(N::Int) = Array{Int, 2}(bitrand(N, N))


circular(N::Int) = Array{Int, 2}([(x - (N + 1) / 2)^2 + (y - (N + 1) / 2)^2
                         for x in 1:N, y in 1:N] .<= N^2 / 2pi)


chess(N::Int) = Array{Int, 2}(repeat([ones(5, 5) zeros(5, 5);
                                       zeros(5, 5) ones(5, 5)],
                                      Int(N / 10), Int(N / 10)))


stripes(N::Int) = Array{Int, 2}([(x+y) % N / 2 < N / 4 for x in 1:N, y in 1:N])


ring(N::Int) = Array{Int, 2}(N^2/4 * (1 - 2/pi) .<= [(x - (N + 1) / 2)^2 + (y - (N + 1) / 2)^2
                         for x in 1:N, y in 1:N] .<= N^2 / 4)
