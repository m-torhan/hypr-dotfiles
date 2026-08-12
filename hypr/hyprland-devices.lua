return function(defaults)
    hl.monitor({ output = "DP-2", mode = "3440x1440@144", position = "0x0", scale = 1, bitdepth = 10 })
    hl.monitor({ output = "DP-3", mode = "3440x1440@144", position = "0x1440", scale = 1, bitdepth = 10 })

    hl.device({
        name = defaults.keyboard,
        kb_layout = "us,pl",
    })
end
