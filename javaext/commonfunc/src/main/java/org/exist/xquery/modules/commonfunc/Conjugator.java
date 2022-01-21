package org.exist.xquery.modules.commonfunc;

public class Conjugator extends BaseClass {
    
  public static String conjugate(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    if (r2_vowel.equals("a")) r2_vowel = a;
    else if (r2_vowel.equals("i")) r2_vowel = i;
    else if (r2_vowel.equals("u")) r2_vowel = u;
    if (root.length() == 3) {
      if (itype.equals("I")) {
        retval = process_tri_verb_form_1(root, itype, tense, r2_vowel);
      } else if (itype.equals("II")) {
        retval = process_tri_verb_form_2(root, itype, tense, r2_vowel);
      } else if (itype.equals("III")) {
        retval = process_tri_verb_form_3(root, itype, tense, r2_vowel);
      } else if (itype.equals("IV")) {
        retval = process_tri_verb_form_4(root, itype, tense, r2_vowel);
      } else if (itype.equals("V")) {
        retval = process_tri_verb_form_5(root, itype, tense, r2_vowel);
      } else if (itype.equals("VI")) {
        retval = process_tri_verb_form_6(root, itype, tense, r2_vowel);
      } else if (itype.equals("VII")) {
        retval = process_tri_verb_form_7(root, itype, tense, r2_vowel);
      } else if (itype.equals("VIII")) {
        retval = process_tri_verb_form_8(root, itype, tense, r2_vowel);
      } else if (itype.equals("X")) {
        retval = process_tri_verb_form_10(root, itype, tense, r2_vowel);
      } else {
        retval = new String("root = (" + root + "), itype = (" + itype + "), tense = " + tense);
      }
    } else {
      retval = "";
    }
    retval = retval.replaceAll(hamza + a + hamza + o, hamza + a + A);
    retval = retval.replaceAll(u + w + o, u + w);
    retval = retval.replaceAll(i + y + o, i + y);
    retval = retval.replaceAll(a + A + o, a + A);
    retval = retval.replaceAll(u + y + o, u + w);
    retval = retval.replaceAll(i + w + o, i + y);
    return Hamzater.hamzate(retval);
  }
  public static String process_tri_verb_form_1(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = r1 + a + r2 + r2_vowel + r3 + a;
    } else {
      retval = y + a + r1 + o + r2 + r2_vowel + r3 + u;
    }
    if (r2.equals(y) && r3.equals(y)) {
      if (tense.equals("0")) {
        if (r2_vowel.equals(a)) {
          retval = r1 + a + r2 + shaddah + a;
        }
      } else {
        if (r2_vowel.equals(a)) {
          retval = y + a + r1 + o + y + a + Y + dagA;
        } else {
          retval = y + a + r1 + o + y + i + y;
        }
      }
    } else if (r2.equals(w) && r3.equals(y)) {
      if (tense.equals("0")) {
        if (r2_vowel.equals(a)) {
          retval = r1 + a + w + a + Y + dagA;
        }
      } else {
        if (r2_vowel.equals(a)) {
          retval = y + a + r1 + o + w + a + Y + dagA;
        } else {
          retval = y + a + r1 + o + w + i + y;
        }
      }
    } else if (r1.equals(w) && r3.equals(y)) {
      if (tense.equals("0")) {
        if (r2_vowel.equals(a)) {
          retval = r1 + a + r2 + r2_vowel + a + Y + dagA;
        }
      } else {
        if (r2_vowel.equals(a)) {
          retval = y + a + r2 + a + Y + dagA;
        } else {
          retval = y + a + r2 + i + y;
        }
      }
    } else if (r2.equals(y) && r3.equals(hamza)) {
      if (tense.equals("0")) {
        if (!r2_vowel.equals(i)) {
          retval = r1 + a + A + hamza + a;
        }
      } else {
        if (r2_vowel.equals(a)) {
          retval = y + a + r1 + a + A + hamza + u;
        } else if (r2_vowel.equals(i)) {
          retval = y + a + r1 + i + y + hamza + u;
        } else {
          retval = y + a + r1 + u + w + i + u;
        }
      }
    } else if (r3.equals(y)) {
      if (tense.equals("0")) {
        if (r2_vowel.equals(a)) {
          retval = r1 + a + r2 + a + Y + dagA;
        }
      } else {
        if (r2_vowel.equals(a)) {
          retval = y + a + r1 + o + r2 + a + Y + dagA;
        } else {
          retval = y + a + r1 + o + r2 + i + y;
        }
      }
    } else if (r3.equals(w)) {
      if (tense.equals("0")) {
        if (r2_vowel.equals(a)) {
          retval = r1 + a + r2 + a + A;
        }
      } else {
        if (r2_vowel.equals(u)) {
          retval = y + a + r1 + o + r2 + u + w;
        }
      }
    } else if (r2.equals(w)) {
      if (tense.equals("0")) {
        if (!r2_vowel.equals(i)) {
          retval = r1 + a + A + r3 + a;
        }
      } else {
        if (r2_vowel.equals(a)) {
          retval = y + a + r1 + a + A + r3 + u;
        } else {
          retval = y + a + r1 + u + w + r3 + u;
        }
      }
    } else if (r2.equals(y)) {
      if (tense.equals("0")) {
        if (!r2_vowel.equals(i)) {
          retval = r1 + a + A + r3 + a;
        }
      } else {
        if (r2_vowel.equals(a)) {
          retval = y + a + r1 + a + A + r3 + u;
        } else {
          retval = y + a + r1 + i + y + r3 + u;
        }
      }
    } else if (r1.equals(w)) {
      if (tense.equals("1")) {
        retval = y + a + r2 + r2_vowel + r3 + u;
      }
    } else if (r2.equals(r3)) {
      if (tense.equals("0")) {
        retval = r1 + a + r2 + shaddah + a;
      } else {
        retval = y + a + r1 + r2_vowel + r3 + shaddah + u;
      }
    }
    return retval;
  }
  public static String process_tri_verb_form_2(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = r1 + a + r2 + shaddah + a + r3 + a;
    } else {
      retval = y + u + r1 + a + r2 + shaddah + i + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = r1 + a + r2 + shaddah + a + Y + dagA; 
      } else {
        retval = y + u + r1 + a + r2 + shaddah + i + y;
      }
    } 
    return retval;
  }
  public static String process_tri_verb_form_3(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = r1 + a + A + r2 + a + r3 + a;
    } else {
      retval = y + u + r1 + a + A + r2 + i + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = r1 + a + A + r2 + a + Y + dagA; 
      } else {
        retval = y + u + r1 + a + A + r2 + i + y;
      }
    } else if (r2.equals(r3)) {
      if (tense.equals("0")) {
        retval = r1 + a + A + r2 + shaddah + a;
      } else {
        retval = y + u + r1 + A + r2 + shaddah + u;
      }
    }
    return retval;
  }
  public static String process_tri_verb_form_4(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = hamza + a + r1 + o + r2 + a + r3 + a;
    } else {
      retval = y + u + r1 + o + r2 + i + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = hamza + a + r1 + o + r2 + a + Y + dagA;
      } else {
        retval = y + u + r1 + o + r2 + i + y;
      }
    } else if (r2.equals(r3)) {
      if (tense.equals("0")) {
        retval = hamza + a + r1 + a + r2 + shaddah + a;
      } else {
        retval = y + u + r1 + i + r2 + shaddah + u;
      }
    }
    return retval;
  }
  public static String process_tri_verb_form_5(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = t + a + r1 + a + r2 + shaddah + a + r3 + a;
    } else {
      retval = y + a + t + a + r1 + a + r2 + shaddah + a + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = t + a + r1 + a + r2 + shaddah + a + Y + dagA; 
      } else {
        retval = y + a + t + a + r1 + a + r2 + shaddah + a + Y + dagA;
      }
    } 
    return retval;
  }
  public static String process_tri_verb_form_6(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = t + a + r1 + a + A + r2 + a + r3 + a;
    } else {
      retval = y + t + a + r1 + a + A + r2 + a + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = t + a + r1 + a + A + r2 + a + Y + dagA; 
      } else {
        retval = y + a + t + a + r1 + a + A + r2 + a + Y + dagA; 
      }
    } else if (r2.equals(r3)) {
      if (tense.equals("0")) {
        retval = t + a + r1 + a + A + r2 + shaddah + a;
      } else {
        retval = y + a + t + a + r1 + A + r2 + shaddah + u;
      }
    }
    return retval;
  }
  public static String process_tri_verb_form_7(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = A + n + o + r1 + a + r2 + a + r3 + a;
    } else {
      retval = y + a + n + o + r1 + a + r2 + i + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = A + n + o + r1 + a + r2 + a + Y + dagA; 
      } else {
        retval = y + a + n + o + r1 + a + r2 + i + y;
      }
    } else if (r2.equals(r3)) {
      if (tense.equals("0")) {
        retval = A + n + o + r1 + a + r2 + shaddah + a;
      } else {
        retval = y + a + n + o + r1 + a + r2 + shaddah + u;
      }
    }
    return retval;
  }
  public static String process_tri_verb_form_8(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = A + r1 + o + t + a + r2 + a + r3 + a;
    } else {
      retval = y + a + r1 + o + t + a + r2 + i + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = A + r1 + o + t + a + r2 + a + Y + dagA; 
      } else {
        retval = y + a + r1 + o + t + a + r2 + i + y;
      }
    } else if (r2.equals(r3)) {
      if (tense.equals("0")) {
        retval = A + r1 + o + t + a + r2 + shaddah + a;
      } else {
        retval = y + a + r1 + o + t + a + r2 + shaddah + u;
      }
    }
    return retval;
  }
  public static String process_tri_verb_form_10(String root, String itype, String tense, String r2_vowel) {
    String retval = "";
    String r1 = "" + root.charAt(0);
    String r2 = "" + root.charAt(1);
    String r3 = "" + root.charAt(2);
    if (tense.equals("0")) {
      retval = A + s + o + t + a + r1 + o + r2 + a + r3 + a;
    } else {
      retval = y + a + s + o + t + a + r1 + o + r2 + i + r3 + u;
    }
    if (r3.equals(y) || r3.equals(w)) {
      if (tense.equals("0")) {
        retval = A + s + o + t + a + r1 + o + r2 + a + Y + dagA; 
      } else {
        retval = y + a + s + o + t + a + r1 + o + r2 + i + y;
      }
    } else if (r2.equals(r3)) {
      if (tense.equals("0")) {
        retval = A + s + o + t + a + r1 + a + r2 + shaddah + a;
      } else {
        retval = y + a + s + o + t + a + r1 + i + r2 + shaddah + u;
      }
    }
    return retval;
  }
  /*
  public static void main(String[] args) {
    System.out.println(process("رجع", "I",  "0", "a"));
    System.out.println(process("رجع", "I",  "1", "i"));
    System.out.println(process("وجد", "I",  "0", "a"));
    System.out.println(process("وجد", "I",  "1", "i"));
    System.out.println(process("يسر", "IV", "0", "a"));
    System.out.println(process("يسر", "IV", "1", "a"));
    System.out.println(process("عدد", "X",  "0", "a"));
    System.out.println(process("عدد", "X",  "1", "a"));
    System.out.println(process("ءوي", "IV", "0", "a"));
    System.out.println(process("ءوي", "IV", "1", "a"));
  }
  */
}
