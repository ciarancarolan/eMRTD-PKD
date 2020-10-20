#!/usr/bin/env zsh

# Split ML into individual certificates
eval $(openssl asn1parse -in $1 -inform der -i | \
       awk "/:d=1/{b=0}
            /:d=1.*SET/{b=1}
	        /:d=2/&&b{print}" |\
       sed 's/^ *\([0-9]*\).*hl= *\([0-9]*\).*l= *\([0-9]*\).*/ \
	     dd if=$1 bs=1 skip=\1 count=$((\2+\3)) 2>\/dev\/null | openssl x509 -inform der -out cert.\1.pem -outform pem;/')

# rm ${CMS_MESSAGE}.der

let count=0
let countcountry=0
echo " " > countrylist.txt
for cert in cert.*.pem; do
	stub="cert"
	C=$(openssl x509 -in $cert -issuer -noout | grep -i -o "C\s*=\s*[A-Z][A-Z]")
	C=$(echo $C | tr '[:lower:]' '[:upper:]')
	auth=${C: -2}
	if ! grep -q $auth countrylist.txt; then
		countcountry=$((countcountry+1))
		echo $auth >> countrylist.txt
	fi
	datestart=$(openssl x509 -in $cert -noout -dates | grep -i "Before" | grep -o "[1-9][0-9][0-9][0-9]")
	dateend=$(openssl x509 -in $cert -noout -dates | grep -i "After" | grep -o "[1-9][0-9][0-9][0-9]") 	
	name=$stub.$auth.$datestart"-"$dateend.pem
	if [ ! -f $name ]; then
		mv $cert $name
	else
		mv $cert $stub.$auth.$datestart"-"$dateend"_2".pem
	fi	
	count=$((count+1))
done


echo "Extracted "$count" files from the masterlist" $1
echo "Certificates belong to "$countcountry "entities" 
#rm countrylist.txt
