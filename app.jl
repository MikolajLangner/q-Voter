using Dash, DashHtmlComponents, DashCoreComponents, Plotly
include("simulations.jl")
include("components.jl")


app = dash(external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css",
                                   "style.css"])

start_N = 100
start_network = random(start_N)
start_opinion = [sum(start_network) / start_N^2]

figure_heatmap = (data = [(x = 1:start_N, y = 1:start_N,
                           z = [2start_network[row, :] .- 1 for row in 1:start_N],
                           type = "heatmap")],
                  layout = (yaxis = (scaleanchor = 'x',),),)
figure_time = (data = [(x = [0], y = [start_opinion])],
               layout = (yaxis = (range = [-1, 1],),))


app.layout = html_div() do
    dcc_graph(id = "state", figure = figure_heatmap),
    dcc_graph(id = "time", figure = figure_time),
    start,
    set,
    nonconformity_dropdown,
    drawing_dropdown,
    pattern_dropdown,
    size_slider,
    q_slider,
    p_slider,
    f_slider,
    dcc_store(id = "data", data = (network = start_network[:, :],
                                    opinion = start_opinion[:],)),
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
    State("pattern", "value"),
    State("size", "value"),
    State("q", "value"),
    State("p", "value"),
    State("f", "value"),
    State("data", "data")
) do step, set, start, nonconformity, drawing, pattern, N, q, p, f, data
    ids = [trigger.prop_id for trigger in callback_context().triggered]
    if "set.n_clicks" in ids
        network = eval(Meta.parse(pattern))
        opinion = [sum(2network .- 1) / N^2]
        return ((z = [[2network[row, :] .- 1 for row in 1:N]],), 0, N),
               ((x = [[0]], y = [[opinion]],), 0, 1),
               (network = network,
               opinion = opinion,)
    end
    network = Array{Int, 2}(reshape(data.network, N, :))
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

port = parse(Int64, ENV["PORT"])
run_server(app, "0.0.0.0", port)

#run_server(app, debug=true)
