module ERFAcal2jd

include("ERFAconst.jl")
using .ERFAconst

export eraCal2jd


function eraCal2jd( iy::Int64, im::Int64, id::Int64)
    djm0 , djm = 0.0, 0.0
# Earliest year allowed (4800BC)
  const IYMIN = -4799

# Month lengths in days
  mtab = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

# Preset status.
  j = 0

# Validate year and month.
  if iy < IYMIN return -1 end
  if im < 1 || im > 12 return -2 end

# If February in a leap year, 1, otherwise 0.
  ly = Int(((im == 2) && !(iy%4) && (iy%100 || !(iy%400))))

# Validate day, taking into account leap years.
  if ( (id < 1) || (id > (mtab[im] + ly))) j = -3 end

# Return result.
  my = (im - 14) / 12
  iypmy = Int64(round(iy + my))
  djm0 = ERFA_DJM0
  djm = Float64(big(Float64((1461 * (iypmy + 4800)) / 4
                + (367 * Int(round(im - 2 - 12 * my))) / 12
                - (3 * ((iypmy + 4900) / 100)) / 4
                + Int(round(id)) - 2432076)))

# Return status.
  return j, djm0, djm
end
end
