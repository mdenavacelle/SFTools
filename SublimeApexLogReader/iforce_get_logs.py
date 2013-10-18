# coding=UTF-8

import os, platform, urllib2, json, logging
import sublime, sublime_plugin

class iforce_get_logsCommand(sublime_plugin.WindowCommand):
	currentProjectFolder = None
	antBin = None

	def run(self, *args, **kwargs):
		logId = '07Lg0000007RAIEEA4'
		sublime.status_message('Recuperation du log '+logId)
		self.currentProjectFolder = self.window.folders()[0]
		print 'iForce: Apex Log Path: ' + self.currentProjectFolder
		thedir = self.currentProjectFolder
		logName = thedir+'/logs/'+logId+'.apexlog'
		theurl = 'https://cs17.salesforce.com/services/data/v28.0/tooling/sobjects/ApexLog/'+logId+'/Body'
		req = urllib2.Request(theurl)
		req.add_header( 'Authorization', 'Bearer 00Dg0000003KmBD!ARUAQPwojnkigd4mDhbmn8vYF8Fosb2t6w5ofc73p1XzNBlZuXciY.dJMX.wmPRMQCG2UH0DEQcq1U_eG4kPL_XMKvSrF5.Y')
		try:
			response = urllib2.urlopen( req)
			data = response.read()
			if len(data) <= 1:
				raise Exception('Reponse vide')
			print 'iForce: Apex Log Retrieved: ' + self.currentProjectFolder
		except Exception, e:
			print( e)
		try:
			outf = open(logName,'w')
			outf.write( data)
			outf.close()
			self.window.open_file(logName)
		except Exception, e2:
			print('Ecriture du log impossible',e)

	def run2(self, *args, **kwargs):
		# Connection automatique en environnement iForce
		self.LogBroker = LogBroker( SFDC(), self.currentProjectFolder+'/logs/')

		# Intégration Sublime Text
		logsList = None
		if args in ['new','all']:
			logsList = self.getLogs(args)
		else:
			logging.exception('Arguments invalides'+args)
			quit()
		
		# Données de logs
		try:
			apexLogs = self.LogBroker.obtain( )
		except Exception, e:
			logging.exception('Erreur lors de la recupération des logs')
			quit()

		# Stockage
		try:
			logBroker.persist( )
		except Exception, e:
			logging.exception('Erreur lors de l\'ecriture des logs')


	def getLogs(self, arg = 'all'):
		query = 'SELECT Id, LogUserId, Request, Operation, Application, Status, SystemModstamp FROM ApexLog'
		if arg is 'new':
			localIds = self.LogBroker.getLocalLogsIdAsList()
			query += ' WHERE Id not in ('+localIds.join(',')+')'

		logs = self.LogBroker.queryList( query)
		return logs


'''
TODO: 
* for loops sans copie ( par référence )
'''
class LogBroker():
	# Configuration
	org    = None
	logdir = None
	logs   = list()

	def LogBroker(self, connection, logdir):
		self.org = connection
		self.logdir = logdir

	def getLocalLogsIdAsList(self):
		# list logs folder content
		# obtain ID from name which is $datetime_$id.apexlog
		# return said id list
		logging.error('Non implémenté')
		return []


	def queryList(self, queryString):
		apiURL = '/query/?q='+urllib2.urllencode( queryString)
		data = self.org.REST( apiURL )
		if len(data) <= 1:
			raise Exception('Reponse vide')

		out = list()
		asJson = json.loads( data)
		print( asJson.totalSize + 'Debug Logs counted')

		# Storing as objects for retreiving body later
		for l in asJson.records:
			log = ApexLog(l)
			self.logs.add( log)
		return logs


	def getLogBody(self, logId):
		apiURL = '/tooling/sobjects/ApexLog/'+logId+'/Body'
		logBody = self.org.REST( apiURL)
		return logBody

	def obtain(self):
		for ix, data in enumerate( self.logs):
			# trying to update the logs stock here...
			self.logs[ix].body = self.getLogBody( i.logId)
		return self.logs

	def persist(self):
		for i in self.logs:
			f = open( i.fileName(),'w')
			f.write( i.body)

'''
Représente un log Salesforce
'''
class Apexlog():
	logId = None
	timestamp = None
	body = None
	version = None
	logLevels = None

	'''
	Remplissage à l'instanciation
	'''
	def Apexlog(self, rawData): None

	def fileName(self):
		return timestamp+'_'+logId+'.apexlog'


'''
Représente une connection à Salesforce
Basé sur iForce et son fichier de connection
'''
class SFDC():
	credentialsFile = None
	sessionId = None
	# REST
	endpoint = 'https://cs17.salesforce.com/services/data/v28.0'

	'''
	Constructeurr
	'''
	def SFDC(self):
		creds = self.readCredentials()
		self.sessionId = self.login( creds)
		self.saveSessionId()

	'''
	Lit le fichier de configuration
	'''
	def readCredentials(self): None

	'''
	Effectue la connection
	'''
	def login(self): None

	'''
	'''
	def logout(self): None

	'''
	Ecrit un fichier contenant l'id de Session
	'''
	def saveSessionId(self): None

	def REST(self, theurl):
		req = urllib2.Request( self.endpoint+theurl)
		req.add_header( 'Authorization', 'Bearer '+self.sessionId)
		response = urllib2.urlopen( req)
		return response.read()
		
