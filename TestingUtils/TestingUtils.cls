/**
* Martin de Navacelle (Ei-Technologies)
*
* Utilitaires pour tests unitaires 
*
* Novembre 2013
*/
public without sharing class TestingUtils {
	
	/* Retourne un utilisateur Standard */
	public static User userFactory()
	{
		return new User(alias = 'test123',
			email = 'test1234@noemail.com',
			emailencodingkey = 'ISO-8859-1',
			lastname = 'Testing',
			languagelocalekey = 'fr',
			localesidkey = 'fr_FR_EURO',
			profileid = [select id from profile where UserType='Standard' limit 1].Id,
			timezonesidkey = 'Europe/Paris',
			username = Datetime.now().getTime()+ '.test.User@test.apec.fr');
	}

	public static Discipline__c disciplineFactory() {
		return new Discipline__c(Name = 'P1', LibelleDiscipline__c = 'Prof', CodeDiscipline__c = 'P1');
	}
	
	/**
	Retourne un Account
	@param options est une liste de maps type clef-valeur representant le nom d'un champ et la valeur qu'on souhaite lui assigner
	*/
    public static Account accountFactory(list<Map<String,String>> options) {
        Account acc = accountFactory();

		/* Mise en place des options par ecrasement */
		for (Map<String,string> o:options) {
			for (String k:o.keySet()) {
				
				acc.put(k, o.get(k));
			}
		}
		return acc;        
    }
	
    /* Version par défaut */
	public static Account accountFactory() {
		
		Account acc = new Account();
        
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cadre').getRecordTypeId();
		
		// isPersonAccount
		acc.FirstName = String.valueOf(Datetime.now().getTime()) + '_' + String.valueOf(randNumber(5));
    	acc.LastName  = 'TestAccount';
		
		acc.BT_IM_RSDCE_PSTAL__C = 'rue';
		acc.CADRESECTEURPRIVE__C = '30081';
		acc.CODE_POSTAL_PHYS__C = '99999';
		acc.CodePstl__c = '75678';
		
		// VR FIELD_CUSTOM_VALIDATION_EXCEPTION
		Discipline__c discipline = disciplineFactory();
		insert discipline;
		acc.Discipline__c = acc.Discipline_secondaire__c = discipline.Id;
		acc.DateObtentionDiplome__c = acc.DateDiplomeSecondaire__c = Date.today();
		acc.Nature__c = acc.NatureSecondaire__c = '20006';
		acc.Niveau__c = acc.NiveauSecondaire__c = '20019';
		
		acc.EMAIL_COMPTEPERSO__C = acc.FirstName + '_testa@test.com';
		acc.FirstName = 'a';
		acc.LastName = 'a';
		acc.LIEUDIT_BP_PHYS__C = '99';
		acc.LIEUDIT_BP_PSTAL__C = 'paris';
		acc.N_ET_LIBEL_V_PSTAL__C = 'tete';
		acc.Salutation = '20064';
		acc.SITUATION_DOSSIER__C = '30072';
		acc.SITUATIONACTUEL__C = '20047';
		acc.SituationCompte__c = '20025';
		acc.Statutactuel__c = '200055';
		acc.VILLE_PHYS__C = '99';
		acc.VILLE_PSTAL__C = '98';
		
    	//acc.SIRET__c = '999999000'; // Bypass en dur, voir TESTAP02Account:73
		
        return acc;
	}
	
    public static list<map<string,string>> optionsFactory(Map<String,String> m) {
        list<map<string,string>> l = new list<map<string,string>>{m};
        return l;
    }

	/* --- TODO: hors scope actuellement. Découpler, SRP
    static testMethod void test_siretGenerator() {
    	//http://fagot.alain.free.fr/helpilaro/verifcle.html
    	//http://www.pixelastic.com/fre/blog/13:validation-et-generation-de-numero-de-siret
    	system.debug(getSiret());
    }
    
    public static string getSiret() {
		
		long resultat = 0;
		string siret;
		string clef;

		resultat= randNumber(8);
		
		clef = clefDeLuhn(resultat);
		
		return (String.valueOf(resultat) + '0000' + clef);
    }
    
    public static string clefDeLuhn(long nombre) {

		integer rang = 0;
		integer impair = 0;
		integer somme = 0;
		integer temp = 0;
		integer actuel = 0;
		integer reste = 0;
		string clef;
		
		integer longueur = Integer.valueOf(String.valueOf(nombre).length());
		
		while (rang < longueur) {
			actuel = Integer.valueOf(String.valueOf(nombre).substring((longueur - rang - 1), (longueur - rang)));
			system.debug('@rang> ' + String.valueOf(rang));
			system.debug('@actuel> ' + String.valueOf(actuel));
			
			if (Math.mod(rang, 2) == 1) {
				impair = actuel;
				system.debug('@impair> ' + String.valueOf(impair));
			} else {
				temp = impair + actuel * 2;
				system.debug('@temp> ' + temp);
				if (temp > 10) {
					// Additionner les deux chiffres revient a soustraire 9
					temp = temp - 9;
					system.debug('@new temp> ' + temp);
				}
				somme += temp;
				system.debug('@somme> ' + somme);
			}
			rang++;
		}
		
		// Fabrication de la clef
		reste = 10 - Math.mod(somme, 10);
		if ( reste > 2 ) {
			integer premier = Integer.valueOf(Math.floor(reste / 3));
			integer second  = reste - (premier * 2);
			clef = String.valueOf(premier * 10 + second);
		} else {
			clef = '0' + String.valueOf(reste);
		}
		return clef;
    }
    //*/
	
	/* Retourn un nombre aléatoire jusqu'a 12 chiffres */
    public static long randNumber(integer combien) {
    	integer debut = 2;
    	integer cible = combien + debut;
    	string res = String.valueOf(Math.random()).substring(debut,cible);
    	system.debug(cible);
    	long res1 = long.valueOf(res); 
    	return res1;
    }
}
