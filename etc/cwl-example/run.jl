#! /usr/bin/env julia

a = parse(Float64, ARGS[1])
b = parse(Float64, ARGS[2])
c = a + b
println(c)