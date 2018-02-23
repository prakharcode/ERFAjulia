module ERFAdat

include("ERFAconst.jl")
using .ERFAconst

export eraDat

struct change
   iyear::Int64
   month::Int64
   delat::Float64
end

function eraDat(iy::Int64, im::Int64, id::Int64, fd = 0.0)
     deltat = 0.0
# Release year for this version of eraDat
    IYV = 2016

# Reference dates (MJD) and drift rates (s/day), pre leap seconds
   drift = (
      ( 37300.0, 0.0012960 ),
      ( 37300.0, 0.0012960 ),
      ( 37300.0, 0.0012960 ),
      ( 37665.0, 0.0011232 ),
      ( 37665.0, 0.0011232 ),
      ( 38761.0, 0.0012960 ),
      ( 38761.0, 0.0012960 ),
      ( 38761.0, 0.0012960 ),
      ( 38761.0, 0.0012960 ),
      ( 38761.0, 0.0012960 ),
      ( 38761.0, 0.0012960 ),
      ( 38761.0, 0.0012960 ),
      ( 39126.0, 0.0025920 ),
      ( 39126.0, 0.0025920 )
   )

# Number of Delta(AT) expressions before leap seconds were introduced
   NERA1 = length(drift)

# Dates and Delta(AT)s
   changes = [
      change( 1960,  1,  1.4178180 ),
      change( 1961,  1,  1.4228180 ),
      change( 1961,  8,  1.3728180 ),
      change( 1962,  1,  1.8458580 ),
      change( 1963, 11,  1.9458580 ),
      change( 1964,  1,  3.2401300 ),
      change( 1964,  4,  3.3401300 ),
      change( 1964,  9,  3.4401300 ),
      change( 1965,  1,  3.5401300 ),
      change( 1965,  3,  3.6401300 ),
      change( 1965,  7,  3.7401300 ),
      change( 1965,  9,  3.8401300 ),
      change( 1966,  1,  4.3131700 ),
      change( 1968,  2,  4.2131700 ),
      change( 1972,  1, 10.0       ),
      change( 1972,  7, 11.0       ),
      change( 1973,  1, 12.0       ),
      change( 1974,  1, 13.0       ),
      change( 1975,  1, 14.0       ),
      change( 1976,  1, 15.0       ),
      change( 1977,  1, 16.0       ),
      change( 1978,  1, 17.0       ),
      change( 1979,  1, 18.0       ),
      change( 1980,  1, 19.0       ),
      change( 1981,  7, 20.0       ),
      change( 1982,  7, 21.0       ),
      change( 1983,  7, 22.0       ),
      change( 1985,  7, 23.0       ),
      change( 1988,  1, 24.0       ),
      change( 1990,  1, 25.0       ),
      change( 1991,  1, 26.0       ),
      change( 1992,  7, 27.0       ),
      change( 1993,  7, 28.0       ),
      change( 1994,  7, 29.0       ),
      change( 1996,  1, 30.0       ),
      change( 1997,  7, 31.0       ),
      change( 1999,  1, 32.0       ),
      change( 2006,  1, 33.0       ),
      change( 2009,  1, 34.0       ),
      change( 2012,  7, 35.0       ),
      change( 2015,  7, 36.0       ),
      change( 2017,  1, 37.0       )
   ]

# Number of Delta(AT) changes
   NDAT = length(changes)
# Miscellaneous local variable(
   djm0, djm = 0,0


# Initialize the result to zero.
   deltat = da = 0.0

# If invalid fraction of a day, set error status and give up.
   if fd < 0.0 || fd > 1.0 return -4 end

# Convert the date into an MJD.
   j, djm0, djm = eraCal2jd(iy, im, id)

# If inchange(alid)year, month, or day, give up.
   if j < 0 return j end

# If pre-UTC year, set warning status and give up.
   if iy < changes[1].iyear return 1 end

# If suspiciously late year, set warning status but proceed.
   if iy > IYV + 5 j = 1 end

# Combine year and month to form a date-ordered integer...
   m = 12*iy + im

# ...and use it to find the preceding table entry.
   for i in NDAT:-1:1
      if m >= (12 * changes[i].iyear + changes[i].month) break end
   end

# Prevent underflow warnings.
   if (i < 1) return -5 end

# Get the Delta(AT).
   da = changes[i].delat

# If pre-1972, adjust for drift.
   if (i < NERA1) da += (djm + fd - drift[i][1]) * drift[i][2] end

# Return the Delta(AT) value.
   deltat = da

# Return the status.
   return j, deltat

end

end
