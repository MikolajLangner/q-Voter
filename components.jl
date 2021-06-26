using DashCoreComponents, DashHtmlComponents

export nonconformity_dropdown, drawing_dropdown, pattern_dropdown,
       size_slider, q_slider, p_slider, f_slider,
       start, set


nonconformity_dropdown = dcc_dropdown(
        id = "nonconformity",
        options = [
            (label = "Anticonformity", value = "anticonformity"),
            (label = "Independence", value = "independence")
        ],
        value = "anticonformity",
    )

drawing_dropdown = dcc_dropdown(
        id = "drawing",
        options = [
            (label = "Without replacement", value = "without"),
            (label = "With replacement", value = "with")
        ],
        value = "without",
    )


pattern_dropdown = dcc_dropdown(
    id = "pattern",
    options = [
        (label = "Random", value = "random(N)"),
        (label = "Circle", value = "circular(N)"),
        (label = "Chessboard", value = "chess(N)"),
        (label = "Stripes", value = "stripes(N)"),
        (label = "Ring", value = "ring(N)")
    ],
    value = "random(N)",
)


size_slider = dcc_slider(
        id = "size",
        min=10,
        max=100,
        step=10,
        value=10,
        tooltip = (always_visible = true,),
        vertical = true,
        verticalHeight = 20
    )

q_slider = dcc_slider(
    id = "q",
    min=1,
    max=8,
    step=1,
    value=3,
    tooltip = (always_visible = true,),
    vertical = true,
    verticalHeight = 20
)

p_slider = dcc_slider(
        id = "p",
        min=0.0,
        max=1.0,
        step=.01,
        value=.1,
        tooltip = (always_visible = true,),
        vertical = true,
        verticalHeight = 100
    )

f_slider = dcc_slider(
        id = "f",
        min=0.0,
        max=1.0,
        step=.01,
        value=.1,
        tooltip = (always_visible = true,),
        vertical = true,
        verticalHeight = 20
    )

start = html_button(
        "Start/Stop",
        id = "start",
        n_clicks = 0
)

set = html_button(
        "Set",
        id = "set",
        n_clicks = 0
)
