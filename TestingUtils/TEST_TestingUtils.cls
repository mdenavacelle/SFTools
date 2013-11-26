/**
	* TEST_TestingUtils - Teste TestingUtils
	* @author: Martin DE NAVACELLE
	* @version: 1.0
*/

@isTest
public class TEST_TestingUtils {

	@isTest
	static void test_userFactory() {
		User u = TestingUtils.userFactory();
        system.assertEquals('test1234@noemail.com', u.email);
	}
    
	@isTest
    static void test_disciplineFactory() {
        Discipline__c di = TestingUtils.disciplineFactory();
        system.assertEquals('P1', di.Name);
    }
    
	@isTest
    static void test_accountFactory() {
        Account a = TestingUtils.accountFactory();
        system.assertEquals('testa@test.com', a.Email_ComptePerso__c);
        
        string expected = 'assertion@test.com';
        map<string,string> o = new map<string,string>();
        o.put('Email_ComptePerso__c', expected);
        
        Account ao = TestingUtils.accountFactory(new list<map<string,string>>{o});
        
        System.assertEquals( expected, ao.Email_ComptePerso__c);
    }
    
    @isTest
    static void test_optionsFactory() {
        list<map<string,string>> expected = new list<map<string,string>>{new map<String,String>{'Clef' => 'Valeur'}};

        list<map<string,string>> options = TestingUtils.optionsFactory(new map<String,String>{'Clef' => 'Valeur'});
        
        system.assertEquals(expected, options);
    }
}
