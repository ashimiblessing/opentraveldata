
##
# Helper functions
#@include "awklib/geo_lib.awk"


##
#
BEGIN {
    # Global variables
    error_stream = "/dev/stderr"
    awk_file = "extract_por_unlc.awk"

    # Header (the master header is in the extract_por_unlc.sh script)
    hdr_line = "unlocode^latitude^longitude^geonames_id^feat_class^feat_code"
    #print (hdr_line)

    #
    today_date = mktime ("YYYY-MM-DD")
    nb_of_geo_por = 0
}


##
# Sample input and output lines:
# iata_code^icao_code^faa_code^is_geonames^geoname_id^valid_id^name^asciiname^latitude^longitude^fclass^fcode^page_rank^date_from^date_until^comment^country_code^cc2^country_name^continent_name^adm1_code^adm1_name_utf^adm1_name_ascii^adm2_code^adm2_name_utf^adm2_name_ascii^adm3_code^adm4_code^population^elevation^gtopo30^timezone^gmt_offset^dst_offset^raw_offset^moddate^city_code^city_name_utf^city_name_ascii^tvl_por_list^state_code^location_type^wiki_link^alt_name_section^wac^wac_name^ccy_code^unlc_list
#
# IEV^UKKK^^Y^6300960^^Kyiv Zhuliany International Airport^Kyiv Zhuliany International Airport^50.401694^30.449697^S^AIRP^0.0240196752049^^^^UA^^Ukraine^Europe^^^^^^^^^0^178^174^Europe/Kiev^2.0^3.0^2.0^2012-06-03^IEV^^^^A^http://en.wikipedia.org/wiki/Kyiv_Zhuliany_International_Airport^en|Kyiv Zhuliany International Airport|=en|Kyiv International Airport|=en|Kyiv Airport|s=en|Kiev International Airport|=uk|Міжнародний аеропорт «Київ» (Жуляни)|=ru|Аэропорт «Киев» (Жуляны)|=ru|Международный аеропорт «Киев» (Жуляни)|^488^Ukraine^HRV^
#
# NCE^LFMN^^Y^6299418^^Nice Côte d'Azur International Airport^Nice Cote d'Azur International Airport^43.658411^7.215872^S^AIRP^0.157408761216^^^^FR^^France^Europe^B8^Provence-Alpes-Côte d'Azur^Provence-Alpes-Cote d'Azur^06^Département des Alpes-Maritimes^Departement des Alpes-Maritimes^062^06088^0^3^-9999^Europe/Paris^1.0^2.0^1.0^2012-06-30^NCE^^^^CA^http://en.wikipedia.org/wiki/Nice_C%C3%B4te_d%27Azur_Airport^de|Flughafen Nizza|=en|Nice Côte d'Azur International Airport|=es|Niza Aeropuerto|ps=fr|Aéroport de Nice Côte d'Azur|=en|Nice Airport|s^427^France^EUR^FRNCE|
#
# RDU^KRDU^^Y^4487056^^Raleigh-Durham International Airport^Raleigh-Durham International Airport^35.87946^-78.7871^S^AIRP^0.0818187017848^^^^US^^United States^North America^NC^North Carolina^North Carolina^183^Wake County^Wake County^^^0^126^124^America/New_York^-5.0^-4.0^-5.0^2011-12-11^RDU|C|4464368=RDU|C|4487042^Durham=Raleigh^Durham=Raleigh^^NC^A^http://en.wikipedia.org/wiki/Raleigh%E2%80%93Durham_International_Airport^^36^North Carolina^USD^USRDU|
#
/^([A-Z]{3}|)\^[A-Z0-9]{0,4}\^[A-Z0-9]{0,4}\^/{
    #
    nb_of_geo_por++

    # Geonames ID
    geonames_id = $5
    
    # Coordinates
    geo_lat = $9
    geo_lon = $10
    
    # Geonames feature class and code
    feat_class = $11
    feat_code = $12

    # UN/LOCODE
    unlc_list = $48

    if (unlc_list != "") {
	# Browse the list of UN/LOCODE codes
	delete unlc_array
	split (unlc_list, unlc_array, "=")
	for (unlc_idx in unlc_array) {
	    unlc_str = unlc_array[unlc_idx]
	    unlc = substr (unlc_str, 1, 5)
	    print (unlc FS geo_lat FS geo_lon FS geonames_id FS feat_class FS feat_code)
	}
    }
}

