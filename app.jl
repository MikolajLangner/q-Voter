using Dash, DashHtmlComponents, DashCoreComponents, Plotly, DataFrames
include("simulations.jl")
include("components.jl")


app = dash()

using Random
N = 100
network = Array{Int, 2}(reshape(bitrand(N^2), N, :))
q = 3
p = rand()
f = rand()
independent = false
replaced = false

max_step = 10^3
opinions = [sum(network) / N^2]

figure_heatmap = (data = [(x = 1:N, y = 1:N,
                           z = [network[row, :] for row in 1:100],
                           type = "heatmap")],)
figure_time = (data = [(x = [0], y = [opinions])],
               layout = (xaxis = (range = [0, max_step],), yaxis = (range = [-1, 1],),))


app.layout = html_div() do
    dcc_graph(id = "state", figure = figure_heatmap),
    dcc_graph(id = "time", figure = figure_time),
    dcc_interval(id = "step")
end


callback!(
    app,
    Output("state", "extendData"),
    Output("time", "extendData"),
    Input("step", "n_intervals")
) do step
    change(network, q, p, f, independent, replaced)
    step = step == nothing ? 1 : step
    global opinions
    opinions = vcat(opinions, sum(network) / N^2)
    return ((z = [[network[row, :] for row in 1:100]],), 0, N),
           ((x = [0:step], y = [opinions],), 0, step + 1)
end

run_server(app, debug=true)
