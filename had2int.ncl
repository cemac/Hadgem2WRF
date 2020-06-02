; ************************************************************************
; An NCL script for converting HadGEM2-ES netCDFs to WRF Intermediates
; ************************************************************************
; based off:
; NCAR cesm2int.ncl
; adapted from hadgem-to-wrf and cesm-to-wrf
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/popRemap.ncl"

begin
  set_default_fillvalue("float",   -1.e30)
  CASE = "rcp85"
  year="2010"
  month="01"
  mth=1
  idx=mth-1
  ens="r2i1p1"
  if ( .not. isvar("CASE") ) then
      print("We need to know which CASE we are running")
    exit
  end if

  if ( .not. isvar("IM_root_name") ) then
    IM_root_name = "Hadgemes2_"+ens+"_"+year+month+"_"+CASE
  else
    IM_root_name = IM_root_name+"_"+CASE
  end if


  if ( .not. isvar("outDIR") ) then
    outDIR = "OUTPUT"
  end if

  in_ta    = addfile(CASE+"/"+ens+"/ta/ta_6hrLev_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+"_"+month+".nc","r")
  in_ua    = addfile(CASE+"/"+ens+"/ua/ua_6hrLev_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+"_"+month+".nc","r")
  in_va    = addfile(CASE+"/"+ens+"/va/va_6hrLev_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+"_"+month+".nc","r")
  in_hus   = addfile(CASE+"/"+ens+"/hus/hus_6hrLev_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+"_"+month+".nc","r")
  in_ps    = addfile(CASE+"/"+ens+"/ps/ps_6hrLev_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+"_"+month+".nc","r")
  in_snw   = addfile(CASE+"/"+ens+"/snw/snw_LImon_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+".nc","r")   ; monthly SWE
  in_mrlsl = addfile(CASE+"/"+ens+"/mrlsl/mrlsl_Lmon_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+".nc","r") ; monthly soil moisture
  in_ts    = addfile(CASE+"/"+ens+"/ts/ts_Amon_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+".nc","r")    ; monthly skin temp
  in_zg    = addfile(CASE+"/"+ens+"/zg/zg_Amon_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+".nc","r") ; geopotential_height
  in_tsl   = addfile(CASE+"/"+ens+"/tsl/tsl_Lmon_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+".nc","r")   ; monthly soil temp
  in_tos   = addfile(CASE+"/"+ens+"/tos/tos_Omon_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+".nc","r")   ; anual SST on NEMO grid
  in_sic   = addfile(CASE+"/"+ens+"/sic/sic_OImon_HadGEM2-ES_"+CASE+"_"+ens+"_"+year+".nc","r")   ; anual SEAICE fraction NEMO
  in_lmask  = addfile(CASE+"/"+ens+"/lmask/sftlf_fx_HadGEM2-ES_"+CASE+"_r0i0p0.nc","r") ; land mask

;************************************************
; read needed variables from file
;************************************************
  print("read variables in")
  time     = in_ta->time
  P0       = 1013.
  lon      = in_ta->lon
  lat      = in_ta->lat
  T        = in_ta->ta
  ; for some reason missing values weren't picked up properly
  ; whatever they are set to set them to -1E30
  ; following METGRID.TBL
  ;T@_FillValue = default_fillvalue("float")
  U        = in_ua->ua
  V        = in_va->va
  ;V@_FillValue = default_fillvalue("float")
  Q        = in_hus->hus
  lpercent = in_lmask->sftlf
  ; land mask from land lpercent
  LMASK = lpercent/100.
  ; turn into binary land or not land
  LMASK = where(LMASK.lt.0.5,0,LMASK)
  LMASK = where(LMASK.ge.0.5,1,LMASK)
  ;Q = where (ismissing(Q), -1.E30, Q)
  ;Q@_FillValue = default_fillvalue("float")
  PS       = in_ps->ps
  PS = where (ismissing(PS), -1.E30, PS)
  ;PS@_FillValue = default_fillvalue("float")
  LAT      = in_ta->lat
  dsizes_x = dimsizes(T)
  ntim     = dsizes_x(0)
  nlev     = dsizes_x(1)
  nlat     = dsizes_x(2)
  nlon     = dsizes_x(3)
  a        = in_ta->lev
  b        = in_ta->b
  ai       = in_ta->lev_bnds(:,1)
  bi       = in_ta->b_bnds(:,1)
  ; take orography from rel Humidity file
  orog      = in_ta->orog
  ;orog = where (ismissing(orog), -1.E30, orog)
  ;orog@_FillValue = default_fillvalue("float")
  PHI       = in_zg->zg
  PHI = where (ismissing(PHI), -1.E30, PHI)
  ;PHI@_FillValue = default_fillvalue("float")
  PHIS      = PHI(idx,0,:,:)*9.81 ; surface geopotential this month
  ZSFC      = orog
  ; POP is actually NEMO
  SST_DAY   = in_tos->tos
  ICE_DAY   = in_sic->sic

; get dimensions from dummy variable
  dsizes_x = dimsizes(T)
  ntim     = dsizes_x(0)
  nlev     = dsizes_x(1)
  nlat     = dsizes_x(2)
  nlon     = dsizes_x(3)

; read in monthly variables and make into 6-hourly
  print("working on monthly variables")
  TSKIN = in_ts->ts
  SNOWW = in_snw->snw
  TSOIL = in_tsl->tsl
  MSOIL = in_mrlsl->mrlsl
  SOILD = in_mrlsl->depth

;convert MSOIL from kg m-2 to fraction
  MSOIL = doubletofloat(MSOIL/(1000.*conform(MSOIL,SOILD,1)))

; now make into 6 hourly variables that change every ~30 days
; note that a *key* assumption here is that we are working with
; data in 3 month chunks each time we run this script!!
; note that soil M & T have 15 layers.  We only need the 4 that
; most closely correspond to the NOAH LSM 0-10,10-40,40-100,100-200 cm layers.
; these were predetermined based on inspection of the layers
; they aren't very important because they get spun up anyway...
  TSKIN6   = PS ; dummy
  SNOWW6   = PS ; dummy
  TSOIL1_6 = PS ; dummy
  TSOIL2_6 = PS ; dummy
  TSOIL3_6 = PS ; dummy
  TSOIL4_6 = PS ; dummy
  MSOIL1_6 = PS ; dummy
  MSOIL2_6 = PS ; dummy
  MSOIL3_6 = PS ; dummy
  MSOIL4_6 = PS ; dummy
  SST6     = PS ; dummy
  ICE6     = PS ; dummy

  TSKIN6(:,:,:)     = conform(PS(:,:,:),  TSKIN(idx,:,:),(/1,2/))
  TAVGSFC6          = TSKIN6              ; This can be used for inland lakes
  ; SST and SEAICE are anual values
  SST6(:,:,:)       = conform(PS(:,:,:),  SST_DAY(0,:,:),(/1,2/))
  ICE6(:,:,:)       = conform(PS(:,:,:),  ICE_DAY(0,:,:),(/1,2/))
  ; rest extrat the years month value
  SNOWW6(:,:,:)     = conform(PS(:,:,:),  SNOWW(idx,:,:),(/1,2/))
  TSOIL1_6(:,:,:)   = conform(PS(:,:,:),  TSOIL(idx,0,:,:),(/1,2/))
  TSOIL2_6(:,:,:)   = conform(PS(:,:,:),  TSOIL(idx,1,:,:),(/1,2/))
  TSOIL3_6(:,:,:)   = conform(PS(:,:,:),  TSOIL(idx,2,:,:),(/1,2/))
  TSOIL4_6(:,:,:)   = conform(PS(:,:,:),  TSOIL(idx,3,:,:),(/1,2/))
  MSOIL1_6(:,:,:)   = conform(PS(:,:,:),  MSOIL(idx,0,:,:),(/1,2/))
  MSOIL2_6          = conform(PS(:,:,:),  MSOIL(idx,1,:,:),(/1,2/))
  MSOIL3_6          = conform(PS(:,:,:),  MSOIL(idx,2,:,:),(/1,2/))
  MSOIL4_6          = conform(PS(:,:,:),  MSOIL(idx,3,:,:),(/1,2/))

; Set missing values to default for METGRID.TBL
  TSOIL1_6 = where (ismissing(TSOIL1_6), -1.E30, TSOIL1_6)
  TSOIL2_6 = where (ismissing(TSOIL2_6), -1.E30, TSOIL2_6)
  TSOIL3_6 = where (ismissing(TSOIL3_6), -1.E30, TSOIL3_6)
  TSOIL4_6 = where (ismissing(TSOIL4_6), -1.E30, TSOIL4_6)
  MSOIL1_6 = where (ismissing(MSOIL1_6), -1.E30, MSOIL1_6)
  MSOIL2_6 = where (ismissing(MSOIL2_6), -1.E30, MSOIL2_6)
  MSOIL3_6 = where (ismissing(MSOIL3_6), -1.E30, MSOIL3_6)
  MSOIL4_6 = where (ismissing(MSOIL4_6), -1.E30, MSOIL4_6)
  SST6     = where (ismissing(SST6), -1.E30, SST6) ; set missing value to default for METGRID.TBL
  ICE6     = where (ismissing(ICE6), -1.E30, ICE6) ; set missing value to default for METGRID.TBL
; Get bottom level temperature for vertical extrapolation
  TBOT     = T(:,0,:,:)

; Calculate height
; hadgem eq: z = lev + b *orog
  print ("calculate Z")
  ;z(k,x,y) =  a (k) +b (k) +orog(x,y)
  Z = conform(Q(:,:,:,:),a,1) + (conform(Q(:,:,:,:),b,1) * conform(Q(:,:,:,:), orog,(/2,3/)))/9.81
  Z@_FillValue = default_fillvalue("float")
  print ("calculate P")
  ; hadgem coordinates are in height
  ; therefore  using  Atmospheric Pressure (P) from
  ; t and z Reference: Burman et al. (1987)
  ; units K, Pa, Pa
  ; put z to (t,lev,x,y)
  ; 1,0,0 = K, hPa, Pa
  ; P= Ps * exp(-g*Z/R0*T)
  ; g is gravity and R0 is dry gas constant
  vt = temp_virtual (T,Q,(/1,0,1/))
  ; P = doubletofloat(conform(T,PS,(/0,2,3/)) * exp((-9.81*Z)/(287*vt)))
  P =  doubletofloat(prsatm_tz_fao56(T, Z, P0, 0, (/1,0,1/)))
  P@_FillValue = default_fillvalue("float")
  ; conver from hPa to Pa
  ; try not having missing values
  if (any(isnan_ieee(P))) then
    if(.not.isatt(P,"_FillValue")) then
      P@_FillValue = default_fillvalue("double")
    end if
    replace_ieeenan (P,0.0 ,0)
  end if
  zfsc =  Z(:,0,:,:)
  zfsc!0 = "time"
  zfsc!1 = "lat"
  zfsc!2 = "lon"
  printVarSummary(zfsc)
  printVarSummary(vt)
  P!0 = "time"
  P!1 = "lev"
  P!2 = "lat"
  P!3 = "lon"

  printVarSummary(P)
  zg = hydro(P(time|:,lat|:,lon|:,lev|:)/100, vt(time|:,lat|:,lon|:,lev|:),zfsc)
  zg!0 = "time"
  zg!1 = "lon"
  zg!2 = "lat"
  zg!3 = "lev"
  zgnew = zg(time|:,lev|:,lon|:,lat|:)
  printVarSummary(zgnew)
  ; Uses stock RH function in ncl
  print("calculate RH")
  R = Q
  ; Q is mixing ration in CESM we need to convert specific hum to mixing ratio
  ;Q = mixhum_convert(Q,"q",(/0,0/))
  ; 1000 coversion between kg/kg to g / kg
  ;printVarSummary(T)
  ;printVarSummary(Q)
  ;printVarSummary(P)
  R = relhum(T, Q, P)
  ;R = R
  R = where(R.gt.100.0, 100.0, R)
  R = where(R.lt.0.0, 0.0, R)
  ;R@_FillValue = default_fillvalue("float")

; Calculate near surface variables (do this instead of take from files do to greater availability of 3d)
; linearly extrapolate T2 in log(P) from 2 lowest hybrid levels)
; Assume RH at 2 m (R2) is same as RH at lowest hybrid level
; calculate Q2 from R2 and T2
; assume U10 and V10 follow a power law for a neutrally stable atmosphere and
; extrapolate them from the lowest hybrid level. Alpha = 0.143
; Hsu, S.A., et al, 1994,J. Appl. Meteor., Vol. 33, pp. 757-765
  print("calculate near surface variables")
  T2 = PS
  ; assume surface values as getting divide by zero terms
  T2 = T(:,0,:,:);-(T(:,1,:,:)-T(:,0,:,:))*((log(PS)-log(P(:,1,:,:)))/(log(P(:,0,:,:))-log(P(:,1,:,:))))
  R2 = R(:,0,:,:)
  ; ZSFC(lat,lon),ps(t,lat,lon)
  ; V(144,192) U(145,192) Z(145,192)
  ; looks ot be missing rather than regridded
  ;printVarSummary(orog)
  U10 = doubletofloat(U(:,0,:,:)*((10./(Z(:,0,:,:)-conform(PS,orog/9.81,(/1,2/))))^0.145))
  V10 = doubletofloat(V(:,0,:,:)*((10./(Z(:,0,0:143,:)-conform(PS(:,0:143,:),orog(0:143,:)/9.81,(/1,2/))))^0.145))

;************************************************
; define other arguments required by vinth2p
;************************************************
; type of interpolation: 1 = linear, 2 = log, 3 = loglog
  interp = 2

; is extrapolation desired if data is outside the range of PS
  extrap = True

; create an array of desired pressure levels:
; include full range
  pnew = (/  1000, 970.0, 950.0, 925.0, 900.0, 850.0, 800.0, 750.0, 700.0, 650.0, 600.0, 550.0, 500.0, \
             450.0, 400.0, 350.0, 300.0, 250.0, 200.0, 150.0, 100.0, 70.0, 50.0, 30.0, 20, 10/)
  pnew = pnew*100

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WRITE OUT DATA TO WRF INTERMEDIATE FORMAT (CALL FORTRAN SUBROUTINE VIA WRAPIT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  print("write out data to WRF intermediate files")

; Set the IM header information
; These are all passed to the write script as resources

  opt = True
  opt@map_source             = "HadGEM2 1.25 x 1.875"
  opt@projection             = 0
  opt@startloc               = "SWCORNER"
  opt@startlon               = doubletofloat(lon(0))
  opt@startlat               = doubletofloat(lat(0))
  opt@deltalon               = doubletofloat(lon(1) - lon(0))
  opt@deltalat               = doubletofloat(lat(1) - lat(0))
  opt@is_wind_earth_relative = False


; set the format to use for the date
  date_format  = "%Y-%N-%D_%H:00:0000000"        		; 24 chars exact for binary file
  date_format2 = "%Y-%N-%D_%H"                                  ; for filename
  yyyy_format  = "%Y" 						; for output directory
  mm_format = "%N"


; Set up field specific header information
  FIELD_T       ="TT"
  UNITS_T       ="K"
  DESC_T        ="Temperature"

  FIELD_U       ="UU"
  UNITS_U       ="m s-1"
  DESC_U        ="Zonal Wind Speed"

  FIELD_V       ="VV"
  UNITS_V       ="m s-1"
  DESC_V        ="Meridional Wind Speed"

  FIELD_Q       ="SPECHUMD"
  UNITS_Q       ="kg kg-1"
  DESC_Q        ="Specific Humidity"

  FIELD_R       ="RH"
  UNITS_R       ="%"
  DESC_R        ="Relative Humidity"

  FIELD_Z       ="GHT"
  UNITS_Z       ="m"
  DESC_Z        ="Geopotential Height"

  FIELD_SLP     ="PMSL"
  UNITS_SLP     ="Pa"
  DESC_SLP      ="Sea level pressure"
  XLVL_SLP      = 201300.

  FIELD_PS      ="PSFC"
  UNITS_PS      ="Pa"
  DESC_PS       ="Surface pressure"

  FIELD_U10     ="UU"
  UNITS_U10     ="m s-1"
  DESC_U10      ="10 m Zonal Wind Speed"

  FIELD_V10     ="VV"
  UNITS_V10     ="m s-1"
  DESC_V10      ="10 m Meridional Wind Speed"

  FIELD_T2      ="TT"
  UNITS_T2      ="K"
  DESC_T2       ="2 m Temperature"

  FIELD_Q2      ="SPECHUMD"
  UNITS_Q2      ="kg kg-1"
  DESC_Q2       ="2 m Specific Humidity"

  FIELD_R2      ="RH"
  UNITS_R2      ="%"
  DESC_R2       ="2 m Relative Humidity"

  FIELD_SNOWW6  ="SNOW"
  UNITS_SNOWW6  ="kg m-2"
  DESC_SNOWW6   ="Water Equivalent of Accum Snow Depth"

  FIELD_TSKIN6  ="SKINTEMP"
  UNITS_TSKIN6  ="K"
  DESC_TSKIN6   ="Skin Temperature"

  FIELD_TAVGSFC6="TAVGSFC"
  UNITS_TAVGSFC6="K"
  DESC_TAVGSFC6 ="Daily mean of surface air temperature"

  FIELD_SST6    ="SST"
  UNITS_SST6    ="K"; 25 chars exact
  DESC_SST6     ="Sea Surface Temperature"

  FIELD_ICE6    ="SEAICE"
  UNITS_ICE6    ="fraction"
  DESC_ICE6     ="Sea-Ice-Fraction"

  FIELD_TSOIL1_6="ST000010"
  UNITS_TSOIL1_6="K"
  DESC_TSOIL1_6 ="Soil Temperature 0-10 cm layer"

  FIELD_TSOIL2_6="ST010040"
  UNITS_TSOIL2_6="K"
  DESC_TSOIL2_6 ="Soil Temperature 10-40 cm layer"

  FIELD_TSOIL3_6="ST040100"
  UNITS_TSOIL3_6="K"
  DESC_TSOIL3_6 ="Soil Temperature 40-100 cm layer"

  FIELD_TSOIL4_6="ST100200"
  UNITS_TSOIL4_6="K"
  DESC_TSOIL4_6 ="Soil Temperature 100-200 cm layer"

  FIELD_MSOIL1_6="SM000010"
  UNITS_MSOIL1_6="fraction"
  DESC_MSOIL1_6 ="Soil Moisture 0-10 cm layer"

  FIELD_MSOIL2_6="SM010040"
  UNITS_MSOIL2_6="fraction"
  DESC_MSOIL2_6 ="Soil Moisture 10-40 cm layer"

  FIELD_MSOIL3_6="SM040100"
  UNITS_MSOIL3_6="fraction"
  DESC_MSOIL3_6 ="Soil Moisture 40-100 cm layer"

  FIELD_MSOIL4_6="SM100200"
  UNITS_MSOIL4_6="fraction"
  DESC_MSOIL4_6 ="Soil Moisture 100-200 cm layer"

  FIELD_ZSFC    ="SOILHGT"
  UNITS_ZSFC    ="m"
  DESC_ZSFC     ="Terrain Elevation"

  FIELD_LMASK   ="LANDSEA"
  UNITS_LMASK   ="proprtn"
  DESC_LMASK    ="Land/Sea Flag; 0=Ocean; 1=Land"

  print("extrapolate variables to pressure levels")
  ; 2 = log interp with extrapolation
  ; 1 = P is dimension 1
  TonP=int2p_n_Wrap(P, T,pnew, -1, 1)
  ;TonP@_FillValue = default_fillvalue("float")
  ZonP=int2p_n_Wrap(P, zgnew, pnew, -1, 1)
  ;ZonP@_FillValue = default_fillvalue("float")
  ;ZonP = where(ZonP.lt.0, 0, ZonP)
  UonP=int2p_n_Wrap(P, U,pnew, -1, 1)
  ;UonP@_FillValue = default_fillvalue("float")
  VonP=int2p_n_Wrap(P(:,:,0:143,:), V,pnew,-1, 1)
  ;VonP@_FillValue = default_fillvalue("float")
  RonP=int2p_n_Wrap(P, R, pnew, -1, 1)
  ;RonP@_FillValue = default_fillvalue("float")
  RonP = where(RonP.gt.100, 100, RonP)
  RonP = where(RonP.lt.0, 100, RonP)
  ;RonP = where (ismissing(RonP), -1.E30, RonP)
  print("-----------------------")
  ;print(ZonP(0,:,50,50))


; Loop through each time period - do final calculations and write data to the IM format
  do TIM = 0,ntim-1

    HDATE = cd_string(time(TIM), date_format)                          ; set dates
    OFILE = IM_root_name+":" + cd_string(time(TIM), date_format2)      ; figure the output file name so that we can clobber it
    yyyy  = cd_string(time(TIM), yyyy_format)                          ; figure out the year so that we can make directories
    print("HDATE= " + HDATE)
    mm =  cd_string(time(TIM), mm_format)
    system ("mkdir -p " + outDIR + "/" + yyyy + "/" + mm)	               	       ; make the output directories
    system ("rm " + OFILE)                                             ; delete the file, so that we don't append to an existing file
    system ("rm " + outDIR + "/" +yyyy+ "/" + mm + "/" + OFILE)                   ; delete the file, so that we don't append to an existing file

    ; calcualte slp using ecmwf formulation (no 6-hourly or 3-hourly slp output is otherwise available)
    ;TV =  temp_virtual(T,Q,0)
    ; seems to work except theres missing values over land
    SLP = doubletofloat(pslhyp (P(:,0,:,:),Z(:,0,:,:),T(:,0,:,:)))
    ;SLP = doubletofloat(pslec(TBOT(TIM,0:143,:),PHIS,PS(TIM,0:143,:),P(TIM,0,0:143,:)))
    SLP = where(SLP.gt.1.E10, -1.E30, SLP)
    SLP = where(SLP.lt.0, -1.E30, SLP)
    ;SLP = where (ismissing(SLP), -1.E30, SLP)
    opt@date = HDATE

    ; write any non-level variables (including treament of soil temp/moisture profiles as single levels each)
    ; Due to the fact that other programs will read these files, and there we assume the fields to in a in given order,
    ; these order of the writes below are import for this application

    opt@level = 200100.
    wrf_wps_write_int(IM_root_name,FIELD_LMASK,UNITS_LMASK,DESC_LMASK, LMASK(:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_ZSFC,UNITS_ZSFC,DESC_ZSFC, doubletofloat(ZSFC(:,:)),opt)
    wrf_wps_write_int(IM_root_name,FIELD_TSKIN6,UNITS_TSKIN6,DESC_TSKIN6, TSKIN6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_TAVGSFC6,UNITS_TAVGSFC6,DESC_TAVGSFC6, TAVGSFC6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_SST6,UNITS_SST6,DESC_SST6, SST6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_ICE6,UNITS_ICE6,DESC_ICE6, ICE6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_SNOWW6,UNITS_SNOWW6,DESC_SNOWW6, SNOWW6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL1_6,UNITS_TSOIL1_6,DESC_TSOIL1_6, TSOIL1_6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL2_6,UNITS_TSOIL2_6,DESC_TSOIL2_6, TSOIL2_6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL3_6,UNITS_TSOIL3_6,DESC_TSOIL3_6, TSOIL3_6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL4_6,UNITS_TSOIL4_6,DESC_TSOIL4_6, TSOIL4_6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL1_6,UNITS_MSOIL1_6,DESC_MSOIL1_6, MSOIL1_6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL2_6,UNITS_MSOIL2_6,DESC_MSOIL2_6, MSOIL2_6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL3_6,UNITS_MSOIL3_6,DESC_MSOIL3_6, MSOIL3_6(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL4_6,UNITS_MSOIL4_6,DESC_MSOIL4_6, MSOIL4_6(TIM,:,:),opt)

    opt@level = XLVL_SLP	; Need a different level for SLP
    ; SLP looked a bit odd and met grid made it much much worse
    wrf_wps_write_int(IM_root_name,FIELD_SLP,UNITS_SLP,DESC_SLP, SLP(TIM,:,:),opt)

    opt@level = 200100.		; Reset level back to regular surface value
    wrf_wps_write_int(IM_root_name,FIELD_PS,UNITS_PS,DESC_PS, PS(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_U10,UNITS_U10,DESC_U10, U10(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_V10,UNITS_V10,DESC_V10, V10(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_T2,UNITS_T2,DESC_T2, T2(TIM,:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_R2,UNITS_R2,DESC_R2, R2(TIM,:,:),opt)


    ; Write each level of the 3D fields out separately
    do LEV=0,dimsizes(pnew)-1

      opt@level = pnew(LEV)
      wrf_wps_write_int(IM_root_name,FIELD_U,UNITS_U,DESC_U, UonP(TIM,LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_V,UNITS_V,DESC_V, VonP(TIM,LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_T,UNITS_T,DESC_T, TonP(TIM,LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_R,UNITS_R,DESC_R, RonP(TIM,LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_Z,UNITS_Z,DESC_Z, doubletofloat(ZonP(TIM,LEV,:,:)),opt)

    end do

    ; move the file to the outDIR directory
      print ("mv " + OFILE + "   " + outDIR + "/" +yyyy+"/"+ mm + "/.")
      system ("mv " + OFILE + "   " + outDIR + "/" +yyyy +"/"+ mm +"/.")
      print("  ")

     delete(HDATE)
     delete(OFILE)
  end do


end
