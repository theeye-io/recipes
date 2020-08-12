#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ] ;then echo "Arguments missing, please run $0 fullfillment.pdf list";fi
if ! which pdftk;then echo "Please install pdftk, sudo snap install pdftk";fi

certificate=$1
list=$(cat "$2")
pdftk "$certificate" generate_fdf output data.fdf
IFS=$'\n' #delimiter
for file  in $list;do
  email=$(echo "$file"|cut -f1 -d$'\t') 
  NameSurname=$(echo "$file"|cut -f2,3,4,5,6 -d$'\t'| tr -s '\t' ' '|sed 'y/āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛ/aaaaeeeeiiiioooouuuuüüüüAAAAEEEEIIIIOOOOUUUUÜÜÜÜ/'|tr [:lower:] [:upper:])
  echo "Procesing $NameSurname with email $email"
  NameSurnameEscaped=${NameSurname// /_}
  sed "s:/V ():/V (                                            $NameSurname):" data.fdf > tmp_data.fdf
  pdftk $certificate fill_form tmp_data.fdf output $(pwd)/output/$email.pdf
  rm tmp_data.fdf
done
