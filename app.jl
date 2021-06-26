using Dash, DashHtmlComponents, DashCoreComponents, Plotly
include("simulations.jl")
include("components.jl")


app = dash()

using Random
N = 100
network = chess(N)
q = 3
p = .01
f = rand()
independent = false
replaced = false

max_step = 10^3
opinions = [sum(2network .- 1) / N^2]

figure_heatmap = (data = [(x = 1:N, y = 1:N,
                           z = [2network[row, :] .- 1 for row in 1:N],
                           type = "heatmap")],
                  layout = (yaxis = (scaleanchor = 'x',),),)
figure_time = (data = [(x = [0], y = [opinions])],
               layout = (yaxis = (range = [-1, 1],),))


app.layout = html_div() do
    dcc_graph(id = "state", figure = figure_heatmap),
    dcc_graph(id = "time", figure = figure_time),
    start,
    set,
    nonconformity_dropdown,
    drawing_dropdown,
    size_slider,
    q_slider,
    p_slider,
    f_slider,
    dcc_store(id = "data", data = (network = network[:, :],
                                    opinion = opinions[:],)),
    dcc_interval(id = "step", interval = 100)
end


callback!(
    app,
    Output("state", "extendData"),
    Output("time", "extendData"),
    Output("data", "data"),
    Input("step", "n_intervals"),
    Input("set", "n_clicks"),
    State("start", "n_clicks"),
    State("nonconformity", "value"),
    State("drawing", "value"),
    State("size", "value"),
    State("q", "value"),
    State("p", "value"),
    State("f", "value"),
    State("data", "data")
) do step, set, start, nonconformity, drawing, N, q, p, f, data
    ids = [trigger.prop_id for trigger in callback_context().triggered]
    if "set.n_clicks" in ids
        network = chess(N)
        opinion = [sum(2network .- 1) / N^2]
        return ((z = [[2network[row, :] .- 1 for row in 1:N]],), 0, N),
               ((x = [[0]], y = [[opinion]],), 0, step + 1),
               (network = network,
               opinion = opinion,)
    end
    network = Array{Int, 2}(reshape(data.network, Int(sqrt(length(data.network))), :))
    if mod(start, 2) == 0
        opinion = data.opinion
    else
        independent = nonconformity == "independence"
        replacement = drawing == "with"
        map(x -> change(network, q, Float64(p), f, independent, replacement), 1:N^2)
        step = step == nothing ? 1 : step
        opinion = vcat(data.opinion, sum(2network .- 1) / N^2)
    end
    return ((z = [[2network[row, :] .- 1 for row in 1:N]],), 0, N),
           ((x = [0:length(opinion)-1], y = [opinion],), 0, length(opinion)),
           (network = network,
           opinion = opinion,)
end

run_server(app, debug=true)
