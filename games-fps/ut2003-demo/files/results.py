#!/usr/bin/env python
# Written by phoen][x <phoenix@gentoo.org>, Sep/19/2002
# Modifications, enhancements or bugs? Mail me.
import sys

def help():
	print "Usage"
	print "  results.py logfile"

def stats(data,mode):
	print(
""">> Score for %s
MinDetail: %f (%d tests)
MaxDetail: %f (%d tests)
Average  : %f (%d tests)
""" % (mode,data[0][0]/data[0][1],data[0][1],data[1][0]/data[1][1],data[1][1],
       (data[0][0]+data[1][0])/(data[0][1]+data[1][1]),data[0][1]+data[1][1]))

args = sys.argv[1:]
if "--help" in args:
	help()
else:
	if len(args):
		file = args[0]
	else:
		import user
		file = "%s/.ut2003/Benchmark/bench.log" % user.home
	try:
		myfile = open(file)
		date = myfile.readline()
		print(">> Results of the UT2003-demo benchmark")
		print(">> created on %s" % date)

		botmatch = ([0,0],[0,0])
		flyby = ([0,0],[0,0])
		
		for line in myfile.readlines():
			results = line.split()
			category = results[0].split("-")[0]

			if results[2] == "MinDetail":
				detail = 0
			elif results[2] == "MaxDetail":
				detail = 1
			else:
				assert "Neither MinDetail nor MaxDetail?"
				
			if category == "botmatch":
				botmatch[detail][0] += float(results[13])
				botmatch[detail][1] += 1
			elif category == "flyby":
				flyby[detail][0] += float(results[13])
				flyby[detail][1] += 1
			else:
				assert "Neither botmach nor flyby?"

		stats(botmatch,"Botmatch")
		stats(flyby,"FlyBy")
		
	except IOError:
		print("Unable to open file %s" % file)
