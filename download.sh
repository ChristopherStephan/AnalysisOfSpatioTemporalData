#!/bin/bash

ROOT=$(pwd)

# 10961 Zugspitze
# 10513 Koeln-Bonn
#URL1="http://www.dwd.de/bvbw/generator/DWDWWW/Content/Oeffentlichkeit/KU/KU2/KU21/klimadaten/german/download/tageswerte/kl__10675__hist__txt,templateId=raw,property=publicationFile.zip/kl_10675_hist_txt.zip"
#URL2="http://www.dwd.de/bvbw/generator/DWDWWW/Content/Oeffentlichkeit/KU/KU2/KU21/klimadaten/german/download/tageswerte/kl__10675__akt__txt,templateId=raw,property=publicationFile.zip/kl_10675_akt_txt.zip"


# "10501" "10505" "10291" "10091" "10852" "10675" "10381" "10382" "10384" "10224" "10453" "10496" "10131" "10488" "10400" "10200" "10554" "10055" "10908" "10578" "10637" "10815" "10439" "10895" "10567" "10532" "10499" "10184" "10791" "10616" "10147" "10338" "10015" "10685" "10962" "10427" "10727" 
ids=( "10438" "10946" "10046" "10513" "10929" "10805" "10469" "10124" "10044" "10393" "10430" "10020" "10361" "10729" "10264" "10548" "10870" "10315" "10270" "10113" "10506" "10763" "10948" "10641" "10742" "10379" "10776" "10731" "10170" "10708" "10035" "10162" "10836" "10788" "10738" "10609" "10007" "10004" "10544" "10688" "10980" "10655" "10961" )



for stationid in "${ids[@]}"
do
	URL1_1='http://www.dwd.de/bvbw/generator/DWDWWW/Content/Oeffentlichkeit/KU/KU2/KU21/klimadaten/german/download/tageswerte/kl__'
	URL1_2='__hist__txt,templateId=raw,property=publicationFile.zip/kl_'
	URL1_3='_hist_txt.zip'
	URL1=$URL1_1$stationid$URL1_2$stationid$URL1_3

	echo $URL1

	URL2_1='http://www.dwd.de/bvbw/generator/DWDWWW/Content/Oeffentlichkeit/KU/KU2/KU21/klimadaten/german/download/tageswerte/kl__'
	URL2_2='__akt__txt,templateId=raw,property=publicationFile.zip/kl_'
	URL2_3='_akt_txt.zip'
	URL2=$URL2_1$stationid$URL2_2$stationid$URL2_3

	echo $URL2

	# Load source files
	rm -r _source
	mkdir _source
	mkdir _source/historic
	mkdir _source/latest
	curl -s $URL1 > _source/historic/historic.zip
	curl -s $URL2 > _source/latest/latest.zip

	# unzip source files
	cd $ROOT/_source/historic
	unzip historic.zip
	rm historic.zip

	cd $ROOT/_source/latest/
	unzip latest.zip
	rm latest.zip

	cd $ROOT

	# convert and merge CSV data

	TXTFILE=$(find _source/historic -iname "produkt*.txt")
	in2csv -f csv -S $TXTFILE|csvcut -C Stations_ID,eor > weather-dwd-$stationid.csv

	TXTFILE=$(find _source/latest -iname "produkt*.txt")
	in2csv -f csv -S $TXTFILE|csvcut -C Stations_ID,eor|tail -n+2 >> weather-dwd-$stationid.csv
done


