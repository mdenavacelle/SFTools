##Basé sur Sublime iForce
* session ID en dur
* Récupère le log dont l'id est en dur
* le sauvegarde dans un dossier "logs" à la racine du projet
* attribue l'extension '.apexlog'
* accessible par le menu iForce

##TODO
* gérer la connection
* récupérer une liste des logs
* télécharger la totalité des logs
* colorisation syntaxique
* unit tests

##Doc

REST GET:

GET /services/data/v28.0/sobjects/ApexLog/07Lg0000007Q64LEAS/Body HTTP/1.1
Host: cs17.salesforce.com
Authorization: Bearer 00Dg0000003KmBD!ARUAQAlOfu9l8wuNA_BenxrYLa3xnMensH7GQonoAd6j6I_4Anhpvhl0w43qo8HgWEiNevMXW74fY_lilJ4dQOJNjFh5SWVB

