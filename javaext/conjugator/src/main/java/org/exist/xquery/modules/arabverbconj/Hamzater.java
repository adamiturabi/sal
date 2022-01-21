package org.exist.xquery.modules.arabverbconj;
import java.util.*;

class ConsInfo {
  public String cons = "";
  public String vowel_mark = "";
  public String vowel = "";
  public String hamza = "";
  public String post_cons_str = "";
  public boolean doubled = false;
  //ConsInfo() {}
  public String toString() {
    return cons + post_cons_str;
  }
}
class Hamzater extends BaseClass {
    static Set<String> letters;
    static Set<String> long_vowels;

  static void initialize() {
    letters = new LinkedHashSet<String>();
    letters.add(A);
    letters.add(b);
    letters.add(p);
    letters.add(t);
    letters.add(v);
    letters.add(j);
    letters.add(H);
    letters.add(x);
    letters.add(d);
    letters.add(dh);
    letters.add(r);
    letters.add(z);
    letters.add(s);
    letters.add(sh);
    letters.add(S);
    letters.add(D);
    letters.add(T);
    letters.add(Z);
    letters.add(E);
    letters.add(g);
    letters.add(f);
    letters.add(q);
    letters.add(k);
    letters.add(l);
    letters.add(m);
    letters.add(n);
    letters.add(h);
    letters.add(w);
    letters.add(y);
    letters.add(hamza);

    long_vowels = new LinkedHashSet<String>();
    long_vowels.add(a+A);
    long_vowels.add(i+y);
    long_vowels.add(u+w);
    long_vowels.add(a+y+o);
    long_vowels.add(a+w+o);
  }
  static String at(String instr, int index) {
    while (index < 0) {
      index += instr.length();
    }
    return Character.toString(instr.charAt(index));
  }
  static String at(String instr, int beg_index, int end_index) {
    String retval = "";
    for (int index = beg_index; index < end_index; index++) {
      retval += Character.toString(instr.charAt(index));
    }
    return retval;
  }
  static ArrayList<ConsInfo> build_cons_list(String instr) {
    ArrayList<ConsInfo> cons_list = new ArrayList<ConsInfo>();
    int index = 0;
    while (index < instr.length()) {
      assert(letters.contains(at(instr, index)));
      ConsInfo cons_info = new ConsInfo();
      cons_info.cons = at(instr, index);
      index++;
      if ((index < instr.length()) && at(instr, index).equals(o)) {
        cons_info.vowel_mark = o;
        cons_info.vowel = o;
        cons_info.post_cons_str += o;
        index++;
        cons_list.add(cons_info);
        continue;
      }
      if ((index < instr.length()) && at(instr, index).equals(shaddah)) {
        cons_info.doubled = true;
        cons_info.post_cons_str += shaddah;
        index++;
      }
      if ((index < instr.length()) && at(instr, index).equals(a)) {
        cons_info.vowel_mark = a;
        cons_info.vowel = a;
        cons_info.post_cons_str += a;
        index++;
        if ((index < instr.length()) && at(instr, index).equals(A)) {
          cons_info.vowel += A;
          cons_info.post_cons_str += A;
          index++;
        } else if ((index < (instr.length()-1)) && at(instr, index, index+2).equals(Y+dagA)) {
          cons_info.vowel += A;
          cons_info.post_cons_str += Y+dagA;
          index += 2;
        } else if ((index < (instr.length()-1)) && at(instr, index, index+2).equals(y+o)) {
          cons_info.vowel += y+o;
          cons_info.post_cons_str += y+o;
          index += 2;
        } else if ((index < (instr.length()-1)) && at(instr, index, index+2).equals(w+o)) {
          cons_info.vowel += w+o;
          cons_info.post_cons_str += w+o;
          index += 2;
        }
        cons_list.add(cons_info);
        continue;
      }
      if ((index < instr.length()) && at(instr, index).equals(i)) {
        cons_info.vowel_mark = i;
        cons_info.vowel = i;
        cons_info.post_cons_str += i;
        index++;
        if ((index == (instr.length()-1) && at(instr, index).equals(y)) || (index < (instr.length()-1) && at(instr, index).equals(y) && letters.contains(at(instr, index+1)))) {
          cons_info.vowel += y;
          cons_info.post_cons_str += y;
          index++;
        }
        cons_list.add(cons_info);
        continue;
      }
      if ((index < instr.length()) && at(instr, index).equals(u)) {
        cons_info.vowel_mark = u;
        cons_info.vowel = u;
        cons_info.post_cons_str += u;
        index++;
        if ((index == (instr.length()-1) && at(instr, index).equals(w)) || (index < (instr.length()-1) && at(instr, index).equals(w) && letters.contains(at(instr, index+1)))) {
          cons_info.vowel += w;
          cons_info.post_cons_str += w;
          index++;
        }
      }
      cons_list.add(cons_info);
    }
    return cons_list;
  }
  static String build_str(ArrayList<ConsInfo> cons_list) {
    String retval = "";
    for (int index=0; index < cons_list.size(); index++) {
      ConsInfo x = cons_list.get(index);
      boolean add_post_str = true;
      if (!x.hamza.equals("")) {
        retval += x.hamza;
        if (x.hamza.equals(A+maddah_above)) {
          add_post_str = false;
        }
      } else {
        retval += x.cons;
      }
      if (add_post_str) {
        retval += x.post_cons_str;
      }
    }
    return retval;
  }
  public static String hamzate(String instr) {
    initialize();
    ArrayList<ConsInfo> cons_list = build_cons_list(instr);
    for (int index = 0; index < cons_list.size(); index++) {
      ConsInfo x = cons_list.get(index);
      if (x.cons.equals(hamza)) {
        if (index == 0) {
          //beginning
          if (x.vowel.equals(a+A)) {
            x.hamza = A+maddah_above;
          } else if (x.vowel_mark.equals(i)) {
            x.hamza = A+hamza_below;
          } else {
            x.hamza = A+hamza_above;
          }
        } else if (index == (cons_list.size()-1)) {
          // end
          ConsInfo prev_cons = cons_list.get(index-1);
          if (!long_vowels.contains(prev_cons.vowel) &&
            !prev_cons.vowel_mark.equals(o) &&
            !(prev_cons.cons.equals(w) && prev_cons.doubled && prev_cons.vowel_mark.equals(u))) {
            if (prev_cons.vowel_mark.equals(i)) {
              x.hamza = y+hamza_above;
            } else if (prev_cons.vowel_mark == u) {
              x.hamza = w+hamza_above;
            } else {
              if (x.vowel_mark.equals(i)) {
                x.hamza = A+hamza_below;
              } else {
                x.hamza = A+hamza_above;
              }
            }
          }
        } else {
          // middle
          ConsInfo prev_cons = cons_list.get(index-1);
          //ConsInfo next_cons = cons_list.get(index+1);
          if (long_vowels.contains(prev_cons.vowel)) {
            if (prev_cons.vowel.equals(i+y) ||
                prev_cons.vowel.equals(a+y+o)) {
            } else if (prev_cons.vowel.equals(u+w) ||
                       prev_cons.vowel.equals(a+w+o)) {
              if (x.vowel_mark.equals(i)) {
                x.hamza = y+hamza_above;
              } else {
                if (x.vowel.equals(a+A) && at(x.post_cons_str, -1).equals(A)) {
                  x.hamza = A+maddah_above;
                } else {
                }
              }
            } else {
              if (x.vowel_mark.equals(i)) {
                x.hamza = y+hamza_above;
              } else if (x.vowel_mark.equals(u)) {
                x.hamza = w+hamza_above;
              } else {
              }
            }
          } else if (prev_cons.vowel_mark.equals(o)) {
            if (x.vowel_mark.equals(i)) {
              x.hamza = y+hamza_above;
            } else if (x.vowel_mark.equals(u)) {
              x.hamza = w+hamza_above;
            } else {
              if (x.vowel.equals(a+A) && at(x.post_cons_str,-1).equals(A)) {
                if (x.doubled) {
                } else {
                  x.hamza = A+maddah_above;
                }
              } else {
                x.hamza = A+hamza_above;
              }
            }
          } else if (x.vowel_mark.equals(o)) {
            if (prev_cons.vowel_mark.equals(i)) {
              x.hamza = y+hamza_above;
            } else if (prev_cons.vowel_mark.equals(u)) {
              x.hamza = w+hamza_above;
            } else {
              x.hamza = A+hamza_above;
            }
          } else {
            if (x.vowel_mark.equals(i) || prev_cons.vowel_mark.equals(i)) {
              x.hamza = y+hamza_above;
            } else if (x.vowel_mark.equals(u) || prev_cons.vowel_mark.equals(u)) {
              x.hamza = w+hamza_above;
            } else {
              if (x.vowel.equals(a+A) && at(x.post_cons_str,-1).equals(A)) {
                if (x.doubled) {
                } else {
                  x.hamza = A+maddah_above;
                }
              } else {
                x.hamza = A+hamza_above;
              }
            }
          }
        }
      }
    }
    boolean apply_tatweel = false;
    if (apply_tatweel) {
      for (int index=1; index < cons_list.size(); index++) {
        ConsInfo x = cons_list.get(index);
        ConsInfo prev_cons = cons_list.get(index-1);
        if (x.cons.equals(hamza) && x.hamza.equals("") &&
          !prev_cons.post_cons_str.contains(A) &&
          !prev_cons.post_cons_str.contains(d) &&
          !prev_cons.post_cons_str.contains(dh) &&
          !prev_cons.post_cons_str.contains(r) &&
          !prev_cons.post_cons_str.contains(z) &&
          !prev_cons.post_cons_str.contains(w)) {
          x.hamza = tatw+hamza_above;
        }
      }
    }
    return build_str(cons_list);
  }
  public static void main(String[] args) {
    List<String> word_list = Arrays.asList("ءِسْلَام", "ءَامَنَ", "ءَسْلَمَ", "ءُرِيدُ", "ءِسْلَام", "ءِيمَان", "ءُوخِذَ", "دُعَاءُ", "سُوءُ", "جِيءَ", "ضَوْءَ", "شَيْءَ", "بُطْءُ", "عِبْءُ", "شَطْءُ", "تَبَوُّءُ", "يُهَدِّء", "سَيِّء", "بَطُء", "يَهْدَء", "مُبْتَدَء", "هَيْءَة", "خَطِيءَة", "بَرِيءُونَ", "بَرِيءَانِ", "بَرِيءِينَ", "بَرِيءَيْنِ", "شَيْءُهُ", "شَيْءَهُ", "شَيْءِهِ", "شَيْءَانِ", "شَيْءَيْنِ", "مَجِيءُهُ", "مَجِيءَهُ", "مَجِيءِهِ", "سُوءِهِ", "ضَوْءِهِ", "سُوءَهُ", "سُوءَانِ", "تَوْءَم", "ضَوْءَهُ", "ضَوْءَانِ", "سُوءُهُ", "يَسُوءُونَ", "سَاءِل", "تَسَاءُل", "تَسَاءَلَ", "قِرَاءَات", "جُزْءَانِ", "عِبْءَانِ", "عِبْءَيْنِ", "بُطْءَهُ", "بُطْءُهُ", "بُطْءِهِ", "مَسْءُول", "تَرْءِيس", "مِرْءَاة", "ظَمْءَان", "مَسْءَلَة", "الْمَرْءَة", "بِءْسَ", "سُءْلَكَ", "كَءْس", "سُءِلَ", "يَءِسَ", "مُتَّكِءِينَ", "رَءِيس", "سُءَال", "رُءُوس", "لُءَيّ", "شَنَءَان", "سَءَلَ", "رَءَىٰ", "رَءَسَ", "يُرَءِسُ", "رُءِّسَ", "تَفَءُّل", "يُبَرِّءُونَ", "يُبَرَّءُونَ", "سَءَّال", "لَءَّال", "اسْتِيءَال", "اسْتَيْءَاس", "نُوءَان");

    for (int index = 0; index < word_list.size(); index++) {
      //String outstr = build_str(build_cons_list("ءَسْلَمَ"));
      System.out.println(hamzate(word_list.get(index)));
      //System.out.println(build_cons_list(word_list.get(index)));
    }
  }
}



