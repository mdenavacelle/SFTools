import os, platform, urllib2
import sublime, sublime_plugin


class iforce_get_logsCommand(sublime_plugin.WindowCommand):
	currentProjectFolder = None
	antBin = None

	def run(self, *args, **kwargs):
		logId = '07Lg0000007Q62REAS'
		sublime.status_message('Recuperation du log '+logId)
		self.currentProjectFolder = self.window.folders()[0]
		print 'iForce: Apex Log Path: ' + self.currentProjectFolder
		thedir = self.currentProjectFolder
		logName = thedir+'/logs/'+logId+'.apexlog'
		theurl = 'https://cs17.salesforce.com/services/data/v28.0/tooling/sobjects/ApexLog/'+logId+'/Body'
		req = urllib2.Request(theurl)
		req.add_header( 'Authorization', 'Bearer 00Dg0000003KmBD!ARUAQAlOfu9l8wuNA_BenxrYLa3xnMensH7GQonoAd6j6I_4Anhpvhl0w43qo8HgWEiNevMXW74fY_lilJ4dQOJNjFh5SWVB')
		try:
			response = urllib2.urlopen( req)
			data = response.read()
		except Exception, e:
			print( e)
		print 'iForce: Apex Log Retrieved: ' + self.currentProjectFolder
		try:
			outf = open(logName,'w')
			outf.write( data)
			outf.close()
		except Exception, e2:
			print('Ecriture du log impossible',e)
		self.window.open_file(logName)
