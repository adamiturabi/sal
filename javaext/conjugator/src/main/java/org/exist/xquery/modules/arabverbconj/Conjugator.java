package org.exist.xquery.modules.arabverbconj;
public class Conjugator {
  public static String process(String root, String form, String tense) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    String a =        "" + '\u064e';
    String u =        "" + '\u064f';
    String i =        "" + '\u0650';
    String shaddah =  "" + '\u0651';
    String o =        "" + '\u0652';
    String t =        "" + '\u062a';
    String s =        "" + '\u0633';
    String y =        "" + '\u064a';
    String A =        "" + '\u0627';
    String n =        "" + '\u0646';
    String hamza_above =  "" + '\u0654';
    if (tense.equals("0")) {
      if (form.equals("II")) {
        retval += r1 + a + r2 + shaddah + a + r3 + a;
      } else if (form.equals("III")) {
        retval += r1 + a + A + r2 + a + r3 + a;
      } else if (form.equals("IV")) {
        retval += A + hamza_above + r1 + o + r2 + a + r3 + a;
      } else if (form.equals("V")) {
        retval += t + a + r1 + a + r2 + shaddah + a + r3 + a;
      } else if (form.equals("VI")) {
        retval += t + a + r1 + a + A + r2 + a + r3 + a;
      } else if (form.equals("VII")) {
        retval += A + n + o + r1 + a + r2 + a + r3 + a;
      } else if (form.equals("VIII")) {
        retval += A + r1 + o + t + a + r2 + a + r3 + a;
      } else if (form.equals("X")) {
        retval += A + s + o + t + a + r1 + o + r2 + a + r3 + a;
      } else {
        retval = "root = (" + root + "), form = (" + form + "), tense = " + tense;
      }
    } else {
      if (form.equals("II")) {
        retval += y + u + r1 + a + r2 + shaddah + i + r3 + u;
      } else if (form.equals("III")) {
        retval += y + u + r1 + a + A + r2 + i + r3 + u;
      } else if (form.equals("IV")) {
        retval += y + u + r1 + o + r2 + i + r3 + u;
      } else if (form.equals("V")) {
        retval += y + a + t + a + r1 + a + r2 + shaddah + a + r3 + u;
      } else if (form.equals("VI")) {
        retval += y + a + t + a + r1 + a + A + r2 + a + r3 + u;
      } else if (form.equals("VII")) {
        retval += y + a + n + o + r1 + a + r2 + i + r3 + u;
      } else if (form.equals("VIII")) {
        retval += y + a + r1 + o + t + a + r2 + i + r3 + u;
      } else if (form.equals("X")) {
        retval += y + a + s + o + t + a + r1 + o + r2 + i + r3 + u;
      } else {
        retval = "root = (" + root + "), form = (" + form + "), tense = " + tense;
      }
    }
    return retval;
  }
  //public static void main(String[] args) {
  //  System.out.println(process("يسر", "VI", "0"));
  //}
}
