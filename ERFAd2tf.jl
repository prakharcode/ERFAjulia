module ERFAd2tf

include("ERFAconst.jl")
using .ERFAconst

export eraD2tf

function eraD2tf(ndp::Int64, days::Float64)

    # int nrs, n
    # double rs, rm, rh, a, w, ah, am, as, af


    # Handle sign.
    sign = Char(( days >= 0.0 ) ? '+' : '-' )

    # Interval in seconds.
    a = ERFA_DAYSEC * abs(days)

    # Pre-round if resolution coarser than 1s (then pretend ndp=1).
    if ndp < 0
        nrs = 1
        for n in range(1,-ndp)
            nrs *= (n == 2 || n == 4) ? 6 : 10
        end
        rs = Float64(nrs)
        w = a / rs
        a = rs * ERFA_DNINT(w)
    end

    # Express the unit of each field in resolution units.
    nrs = 1
    for n in range(1,ndp)
        nrs *= 10
    end
    rs = Float64(nrs)
    rm = rs * 60.0
    rh = rm * 60.0

    # Round the interval and express in resolution units.
    a = ERFA_DNINT(rs * a)

    # Break into fields.
    ah = a / rh
    ah = ERFA_DINT(ah)
    a -= ah * rh
    am = a / rm
    am = ERFA_DINT(am)
    a -= am * rm
    as = a / rs
    as = ERFA_DINT(as)
    af = a - as * rs
    ihmsf = Array{Int64,1}(4)
    # Return results.
    ihmsf[1] = Int64(round(ah))
    ihmsf[2] = Int64(round(am))
    ihmsf[3] = Int64(round(as))
    ihmsf[4] = Int64(round(af))

    return ihmsf,sign
end
end
