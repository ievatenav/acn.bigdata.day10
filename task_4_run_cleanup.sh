{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf200
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Extracting data from the file\
content=$(hdfs dfs -cat /user/cloudera/day_10/STEP1/*.csv);\
\
# Cleaning data\
content_edited=$(echo "$content" | grep -v '^!');\
\
# Getting row count for validation\
row_valid=$(echo "$\{content\}" | tail -1 | grep -Eo [0-9]);\
\
# Counting rows\
row_actual=$(echo "$\{content_edited\}" | grep -vc '^!');\
\
# Validating row count\
if [ $row_valid -eq $row_actual ]; then\
\
	# Adding file into HDFS\
	new_filename=$(hdfs dfs -ls /user/cloudera/day_10/STEP1/* | grep -o -P '(?<=STEP1/).*(?=.csv)' )_s2.csv;\
	date_dir=$(date '+%Y/%m/%d')\
	echo "$\{content_edited\}" | hdfs dfs -put - /user/cloudera/day_10/STEP2/$date_dir/$new_filename;\
\
	# Adding a _SUCCESS file for validation in the next step\
	hdfs dfs -touchz /user/cloudera/day_10/STEP2/$(date_dir)/_SUCCESS;\
\
else\
	echo "The file is not validated - row count don\'92t match.";\
fi}