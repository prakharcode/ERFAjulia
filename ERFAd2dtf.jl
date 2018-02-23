module ERFAd2dtf


include("ERFAjd2cal.jl")
include("ERFAdat.jl")
include("ERFAd2tf.jl")
include("ERFAconst.jl")

using .ERFAconst, .ERFAd2tf, .ERFAdat, .ERFAjd2cal


export eraD2dtf

function eraD2dtf(scale::String, ndp::Int64, d1::Float64, d2::Float64)

     # The two-part JD.
      a1 = d1
      b1 = d2

     # Provisional calendar date.
      js, iy1, im1, id1, fd = eraJd2cal(a1, b1)
      if ( js != 0 ) return -1 end

     # Is this a leap second day?
      leap = 0
    if scale=="UTC"

      # TAI-UTC at 0h today.
         js, dat0 = eraDat(iy1, im1, id1, 0.0)
         if ( js < 0 ) return -1 end

      # TAI-UTC at 12h today (to detect drift).
         js, dat12 = eraDat(iy1, im1, id1, 0.5)
         if ( js < 0 ) return -1 end

      # TAI-UTC at 0h tomorrow (to detect jumps).
         js, iy2, im2, id2, w = eraJd2cal(a1+1.5, b1-fd)
         if ( js!=0 ) return -1 end
         js, dat24 = eraDat(iy2, im2, id2, 0.0)
         if ( js < 0 ) return -1 end

      # Any sudden change in TAI-UTC (seconds).
         dleap = Float64(dat24 - (2.0*dat12 - dat0))

      # If leap second day, scale the fraction of a day into SI.
         leap = (dleap != 0.0)
         if leap !=0  fd += (fd * dleap/ERFA_DAYSEC) end
    end

     # Provisional time of day.
    ihmsf1, s = eraD2tf(ndp, fd)

     # Has the (rounded) time gone past 24h?
    if  ihmsf1[1] > 23

      # Yes.  We probably need tomorrow's calendar date.
        js, iy2, im2, id2, w = eraJd2cal(a1+1.5, b1-fd)
        if ( js != 0 ) return -1 end

      # Is today a leap second day?
        if !leap
            # No.  Use 0h tomorrow.
            iy1 = iy2
            im1 = im2
            id1 = id2
            ihmsf1[1] = 0
            ihmsf1[2] = 0
            ihmsf1[3] = 0

        else

         # Yes.  Are we past the leap second itself?
            if ( ihmsf1[3] > 0 )

            # Yes.  Use tomorrow but allow for the leap second.
               iy1 = iy2
               im1 = im2
               id1 = id2
               ihmsf1[1] = 0
               ihmsf1[2] = 0
               ihmsf1[3] = 0

            else

            # No.  Use 23 59 60... today.
               ihmsf1[1] = 23
               ihmsf1[2] = 59
               ihmsf1[3] = 60
           end

         # If rounding to 10s or coarser always go up to new day.
            if ( ndp < 0 && ihmsf1[3] == 60 )
               iy1 = iy2
               im1 = im2
               id1 = id2
               ihmsf1[1] = 0
               ihmsf1[2] = 0
               ihmsf1[3] = 0
            end
        end
    end

     # Results.
    iy = iy1
    im = im1
    id = id1
    ihmsf = Array{Int64,1}(4)
    for i in range(1, 4)
         ihmsf[i] = ihmsf1[i]
    end

     # Status.
    return iy, im, id, ihmsf[1], ihmsf[2], ihmsf[3], ihmsf[4]



end
end
