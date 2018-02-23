module ERFAconst

export eraASTROM, eraLDBODY, ERFA_DPI, ERFA_D2PI, ERFA_DR2D, ERFA_DD2R, ERFA_DR2AS,
    ERFA_DAS2R, ERFA_DS2R, ERFA_TURNAS, ERFA_DMAS2R, ERFA_DTY, ERFA_DAYSEC, ERFA_DJY,
    ERFA_DJC, ERFA_DJM, ERFA_DJ00, ERFA_DJM0, ERFA_DJM00, ERFA_DJM77, ERFA_TTMTAI, ERFA_DAU,
    ERFA_CMPS, ERFA_AULT, ERFA_DC, ERFA_ELG, ERFA_ELB, ERFA_TDB0, ERFA_SRS, ERFA_WGS84, ERFA_GRS80,
    ERFA_WGS72, ERFA_DINT, ERFA_DNINT, ERFA_DSIGN, ERFA_GMAX, ERFA_GMIN



struct eraASTROM
     pmt::Float64                   # PM time interval (SSB, Julian years)
     eb::Array{Float64,1}         # SSB to observer (vector, au)
     eh::Array{Float64,1}         # Sun to observer (unit vector)
     em::Float64                    # distance from Sun to observer (au)
     v::Array{Float64,1}          # barycentric observer velocity (vector, c)
     bm1::Float64                   # sqrt(1-|v|^2): reciprocal of Lorenz factor
     bpn::Array{Float64,2}       # bias-precession-nutation matrix
     along::Float64                 # longitude + s' + dERA(DUT) (radians)
     phi::Float64                   # geodetic latitude (radians)
     xpl::Float64                   # polar motion xp wrt local meridian (radians)
     ypl::Float64                   # polar motion yp wrt local meridian (radians)
     sphi::Float64                  # sine of geodetic latitude
     cphi::Float64                  # cosine of geodetic latitude
     diurab::Float64                # magnitude of diurnal aberration vector
     eral::Float64                  # "local" Earth rotation angle (radians)
     refa::Float64                  # refraction constant A (radians)
     refb::Float64                  # refraction constant B (radians)
 end
 struct eraLDBODY
     bm::Float64                    # mass of the body (solar masses)
     dl::Float64                    # deflection limiter (radians^2/2)
     pv::Array{Float64,2}           # barycentric PV of the body (au, au/day)
  end






  # Pi
  const ERFA_DPI = 3.141592653589793238462643

  # 2Pi
  const ERFA_D2PI = 6.283185307179586476925287

  #Radians to degrees
  const ERFA_DR2D = 57.29577951308232087679815

  #Degrees to radians
  const ERFA_DD2R = 1.745329251994329576923691e-2

  # Radians to arcseconds
  const ERFA_DR2AS  = 206264.8062470963551564734

  # Arcseconds to radians
  const ERFA_DAS2R = 4.848136811095359935899141e-6

  #Seconds of time to radians
  const ERFA_DS2R = 7.272205216643039903848712e-5

  #Arcseconds in a full circle
  const ERFA_TURNAS = 1296000.0

  # Milliarcseconds to radians
  const ERFA_DMAS2R = ERFA_DAS2R / 1e3

  # Length of tropical year B1900 (days)
  const ERFA_DTY = 365.242198781

  #Seconds per day
  const ERFA_DAYSEC  = 86400.0

  # Days per Julian year
  const ERFA_DJY  = 365.25

  # Days per Julian century
  const ERFA_DJC = 36525.0

  # Days per Julian millennium
  const ERFA_DJM = 365250.0

  # Reference epoch (J2000.0), Julian Date
  const ERFA_DJ00 = 2451545.0

  # Julian Date of Modified Julian Date zero
  const ERFA_DJM0 = 2400000.5

  # Reference epoch (J2000.0), Modified Julian Date
  const ERFA_DJM00 = 51544.5

  # 1977 Jan 1.0 as MJD
  const ERFA_DJM77 = 43144.0

  # TT minus TAI (s)
  const ERFA_TTMTAI = 32.184

  # Astronomical unit (m, IAU 2012)
  const ERFA_DAU  = 149597870.7e3

  # Speed of light (m/s)
  const ERFA_CMPS = 299792458.0

  # Light time for 1 au (s)
  const ERFA_AULT = ERFA_DAU/ERFA_CMPS

  # Speed of light (au per day)
  const ERFA_DC  = ERFA_DAYSEC / ERFA_AULT

  # L_G = 1 - d(TT)/d(TCG)
  const ERFA_ELG  = 6.969290134e-10

  # L_B = 1 - d(TDB)/d(TCB), and TDB (s) at TAI 1977/1/1.0
  const ERFA_ELB  = 1.550519768e-8
  const ERFA_TDB0 = -6.55e-5

  # Schwarzschild radius of the Sun (au)
  # = 2 * 1.32712440041e20 / (2.99792458e8)^2 / 1.49597870700e11
  const ERFA_SRS = 1.97412574336e-8

  # ERFA_DINT(A) - truncate to nearest whole number towards zero (double)
  ERFA_DINT(A) = A < 0.0? ceil(A):floor(A)

  # ERFA_DNINT(A) - round to nearest whole number (double)
  ERFA_DNINT(A) = A < 0.0? ceil(A-0.5):floor((A)+0.5)

  # ERFA_DSIGN(A,B) - magnitude of A with sign of B (double)
  ERFA_DSIGN(A,B) = B < 0.0? -fabs(A):fabs(A)

  # max(A,B) - larger (most +ve) of two numbers (generic)
  ERFA_GMAX(A,B) = A > B ?(A):(B)

  # min(A,B) - smaller (least +ve) of two numbers (generic)
  ERFA_GMIN(A,B) = A < B ?(A):(B)

  # Reference ellipsoids
  const ERFA_WGS84 = 1
  const ERFA_GRS80 = 2
  const ERFA_WGS72 = 3

end
