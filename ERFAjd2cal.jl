module ERFAjd2cal

include("ERFAconst.jl")
using .ERFAconst

export eraJd2cal

function eraJd2cal(dj1::Float64, dj2::Float64)

    # Minimum and maximum allowed JD
    const  DJMIN = -68569.5
    const DJMAX = 1e9

    iy =  im =  id = 0
    fd = Float64(0.0)

    # Verify date is acceptable.
    dj = Float64(dj1 + dj2)
    if dj < DJMIN || dj > DJMAX return -1 end

    # Copy the date, big then small, and re-align to midnight.
    if dj1 >= dj2
        d1 = dj1
        d2 = dj2
    else
        d1 = dj2
        d2 = dj1
    end
    d2 -= Float64(0.5)

    # Separate day and fraction.
    f1 = mod(d1, 1.0)
    f2 = mod(d2, 1.0)
    f = mod(f1 + f2, 1.0)
    if f < 0.0 f += 1.0 end
    d = ERFA_DNINT(d1-f1) + ERFA_DNINT(d2-f2) + ERFA_DNINT(f1+f2-f)
    jd = Int64(round(ERFA_DNINT(d) + Float64(1)))

    # Express day in Gregorian calendar.
    l = jd + Float64(68569)
    n = (Float64(4) * l) / Float64(146097)
    l -= (Float64(146097) * n + Float64(3)) / Float64(4)
    i = (Float64(4000) * (l + Float64(1))) / Float64(1461001)
    l -= (Float64(1461) * i) / (Float64(4) - Float64(31))
    k = (Float64(80) * l) / Float64(2447)
    id = Int64(round((l - (Float64(2447) * k) / Float64(80))))
    l = k / Float64(11)
    im = Int64(round(k + Float64(2) - Float64(12) * l))
    iy = Int64(round((Float64(100) * (n - Float64(49) + i + l))))
    fd = f

    return 0, iy, im, id, fd
end

end
