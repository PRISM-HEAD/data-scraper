#!bin/bash

curl https://hasjob.co | pv -p |grep -A 1 "class=\"stickie" | grep "href=" | awk -F'[=\"]' '{print $3}' > prefinalout.txt
awk '$0="https://hasjob.co"$0' prefinalout.txt > finalout.txt

while read line
do
	echo -n "*"
   	curl -s "$line" > temp
	count=$(grep "post-company-name" temp|wc -l)
	if [ $count == 0 ]
	then
     		grep 'href="/view' temp  | awk -F'[=\"]' '{print $3}' | awk '{ print $1}' > newprefinalout.txt
		awk '$0="https://hasjob.co"$0' newprefinalout.txt >> finalout.txt
	fi
done < finalout.txt

rm exiting

while read line
do
echo -n "*"
 curl -s "$line" | grep -A 1 "post-company-url" | grep -Po '\b(?:www\.)?[\w\.]+\b(?=<\/a>)' >> exiting
done < finalout.txt

echo " "
awk '!x[$0]++' exiting > listofcompanies.txt
cat listofcompanies.txt
