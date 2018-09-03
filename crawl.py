from bs4 import BeautifulSoup
import urllib2
from urllib2 import httplib
from HTMLParser import HTMLParser  
facFiles=[]
def getFaculty(url):
	baseUrl="http://www.iitkgp.ac.in"
	fac_url=baseUrl+url
	# print fac_url
	fac_url=fac_url.split(';')
	# print fac_url[0]
	data=fac_url[0]
	data=data.split('-')
	name=data[1]
	name=name+".html"
	# name2=data[1]+".txt"
	# # print name
	facFiles.append(name)
	fp=open(name,"w+")
	fp.truncate()
	# fp1=open(name2,"w+")
	# fp1.truncate()
	try:
		page = urllib2.urlopen(fac_url[0])
	except httplib.IncompleteRead as e:
		print "Partial Read"
		page=e.partial
	print page
	soup = BeautifulSoup(page)
	fp.write((soup.prettify()).encode('utf-8'))
	# fp1.write((soup.prettify()).encode('utf-8'))

try:
	page = urllib2.urlopen("http://www.iitkgp.ac.in/department/CS")
except httplib.IncompleteRead as e:
	print "Partial Read"
	page=e.partial
soup = BeautifulSoup(page)
fp=open("output.txt","w+")
fp.write((soup.prettify()).encode('utf-8'))
head_links=soup.findAll('h4')
for a in soup.find_all('a', href=True):
    url=a['href']
    if ('faculty/cs') in url:
    	getFaculty(url)

print "\nTotal faculties:" + str(len(facFiles))+"\n"
print facFiles
