module ERFAdtf2d

include("ERFAconst.jl")
include("ERFAcal2jd.jl")
include("ERFAdat.jl")
include("ERFAjd2cal.jl")

using .ERFAconst
using .ERFAcal2jd
using .ERFAdat
using .ERFAjd2cal


export eraDtf2d


function eraDtf2d(scale::String, iy::Int64, im::Int64, id::Int64, ihr::Int64, imn::Int64, sec::Float64)
     # Today's Julian Day Number.
     d1, d2 = 0.0 , 0.0
    js, dj, w = eraCal2jd(iy, im, id)
    if js!=0 return js end
    dj += w

     # Day length and final minute length in seconds (provisional).
    day = ERFA_DAYSEC
    seclim = 60.0

     # Deal with the UTC leap second case.
    if scale == "UTC"
         # TAI-UTC at 0h today.
        js, dat0 = eraDat(iy, im, id, 0.0)
        if js < 0 return js end

     # TAI-UTC at 12h today (to detect drift).
        js, dat12 = eraDat(iy, im, id, 0.5)
        if js < 0 return js end
         # TAI-UTC at 0h tomorrow (to detect jumps).
         js, iy2, im2, id2, w = eraJd2cal( dj, 1.5)
         if js!= 0 return js end

         js, dat24= eraDat(iy2, im2, id2, 0.0)
         if js < 0 return js end

         # Any sudden change in TAI-UTC between today and tomorrow.
         dleap = dat24 - (2.0*dat12 - dat0)

         # If leap second day, correct the day and final minute lengths.
         day += dleap
         if (ihr == 23 && imn == 59) seclim += dleap end

         # End of UTC-specific actions.
    end

     # Validate the time.
    if ihr >= 0 && ihr <= 23
        if imn >= 0 && imn <= 59
            if sec >= 0
                if sec >= seclim
                     js += 2
                end
            else
                js = -6
            end
        else
            js = -5
        end
    else
        js = -4
    end

    if js < 0 return js end

     # The time in days.
     time  = (60.0 * (Float64(( 60 * ihr + imn ))) + sec) / day

     # Return the date and time.
     d1 = dj
     d2 = time

     # Status.

     return (d1, d2)

end
end
