#! /usr/bin/env bash
cd $1
# round all numeric columns to 5 decimal places and find the md5sums
cat *immunedeconv_CIBERSORT-Percentiles.csv | awk -F',' '{printf "%s %.5f %.5f\n", $1, $2, $3}' | md5sum
cat *immunedeconv_CIBERSORT-Results.tsv | awk '{printf "%s %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f %.5f \n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26}' | md5sum
