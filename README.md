# eMRTD-PKD
Examples of code for handling public key data and file formats associated with ICAO compliant travel documents

Code is stored in the 'master' branch.

In order to use the code, you should have openssl in your path. Some versions of openssl are unable to handle certain ICAO-conformant files, including the ICAO master list. It is recommended that version 1.0.2 be used.

The following code snippets are available:

1. split_ML.sh. 
This UNIX shell script is used to extract individual CSCA public key certificates from an ICAO-compliant master list. 
The script is called taking the master list as the first and only argument. The master list should be in ASN1 DER format. 
The script writes out all certificates individually, referencing the issuing State code, the date of first use and the date of expiry.
A file countrylist.txt is created listing all countries included in the master list.
