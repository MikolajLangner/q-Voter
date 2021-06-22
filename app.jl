using Dash, DashHtmlComponents, DashCoreComponents, Plotly

app = dash()

df = DataFrame(x = 1:10, y = 1:10)

app.layout = html_div() do
    dcc_graph(id = "state"),
    dcc_interval(id = "step")
end

callback!(
    app,
    Output("state", "figure"),
    Input("step", "n_intervals"),
) do year
    df.y .^= 2
    return Plot(df, x = :x, y = :y)
end


run_server(app, debug=true)
