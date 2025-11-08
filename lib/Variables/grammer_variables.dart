import 'package:flutterkeysaac/Variables/variables.dart';

class Gv4rs {
    static String get oldText => V4rs.message.value.trim();
    static String get lastWord => oldText.split(" ").last;
    static String get lastChar => oldText.substring(oldText.length -1);

    static bool endsWith(String text) {
      return oldText.endsWith(text);
    }
    static bool startsWith(String text) {
      return lastWord.startsWith(text);
    }
    static String deleteLastChar(String text) {
      return text.substring(0, text.length - 1);
    }
    static String deleteLastAmount(String text, int number) {
      return text.substring(0, text.length - number);
    }
    static String appendWord(String addition){
      if (V4rs.message.value.isEmpty) return V4rs.message.value;
      return V4rs.message.value = oldText + addition;
    }
    static String appendStartWord(String addition){
      if (V4rs.message.value.isEmpty) return V4rs.message.value;
      String textWithoutLastWord = deleteLastAmount(oldText, lastWord.length);

      return V4rs.message.value = (
        textWithoutLastWord + addition + lastWord
        );
    }
    static String deleteStartAmount(int number) {
      String textWithoutLastWord = deleteLastAmount(oldText, lastWord.length);

      return V4rs.message.value = ( 
       textWithoutLastWord + lastWord.substring(number)
      );
    }
    static String swapLastFor(String text){
      if (V4rs.message.value.isEmpty) return V4rs.message.value;

      List<String> words = oldText.split(" ");
      if (words.isEmpty) return V4rs.message.value;

       words.removeLast();
       words.add(text);
       
       return V4rs.message.value = words.join(" ");
    }

  //
  //Special Helper funcs
  //

  static bool hasCVCEnding(String lastWord) {
      const vowels = "aeiouy";
      const consonants = "bcdfghjklmnpqrstvwxyz";

      if (lastWord.length < 3) return false;

      String lower = lastWord.toLowerCase();
      String last = lower[lower.length - 1];
      String secondLast = lower[lower.length - 2];
      String thirdLast = lower[lower.length - 3];

      return consonants.contains(last) &&
            vowels.contains(secondLast) &&
            consonants.contains(thirdLast);
    }
  
  static int countSyllables(String word) {
    if (word.isEmpty) return 0;
      const vowels = "aeiouyAEIOUY";
      bool lastWasVowel = false;
      int count = 0;
      for (int i = 0; i < word.length; i++) {
        String char = word[i];

        if (vowels.contains(char)) {
          if (!lastWasVowel) {
            count += 1;
          }
          lastWasVowel = true;
        } else {
          lastWasVowel = false;
        }
      }
      // remove silent e
      if (word.toLowerCase().endsWith('e') && count > 1) {
        count -= 1;
      }
      return count < 1 ? 1 : count; // 0 syllables is banned
  }

  static bool hasCosonantSecondToLastEnding(String lastWord) {
      const consonants = "bcdfghjklmnpqrstvwxyz";

      if (lastWord.length < 2) return false;

      String lower = lastWord.toLowerCase();
      String last = lower[lower.length - 2];

      return consonants.contains(last);
    }

  static String swapLastVowelForA(String lastWord) {
    const vowels = "aeiouy";

    if (lastWord.isEmpty) return oldText;

    String lower = lastWord.toLowerCase();
    for (int i = lower.length - 1; i >= 0; i--) {
      if (vowels.contains(lower[i])) {
        //fist part of word, replase vowel with A, rest of the word
       String newLast = "${lastWord.substring(0, i)}a${lastWord.substring(i + 1)}";
       return swapLastFor(newLast);
      }
    }
    // If no vowel
    return oldText;
  }

  static String swapLastVowelForU(String lastWord) {
    const vowels = "aeiouy";

    if (lastWord.isEmpty) return oldText;

    String lower = lastWord.toLowerCase();
    for (int i = lower.length - 1; i >= 0; i--) {
      if (vowels.contains(lower[i])) {
        //fist part of word, replase vowel with A, rest of the word
       String newLast = "${lastWord.substring(0, i)}u${lastWord.substring(i + 1)}";
       return swapLastFor(newLast);
      }
    }
    // If no vowel
    return oldText;
  }

  static String swapFirstTwoVowelForO(String lastWord) {
    const vowels = "aeiouy";

    if (lastWord.isEmpty) return oldText;

    int replaced = 0;
    StringBuffer result = StringBuffer();

    for (int i = 0; i < lastWord.length; i++) {
      String ch = lastWord[i];

      if (vowels.contains(ch.toLowerCase()) && replaced < 2) {
        result.write("o"); // replace with 'o'
        replaced++;
      } else {
        result.write(ch);
      }
    }
    return swapLastFor(result.toString());
  }

  static String deleteLastE(String lastWord) {
    if (lastWord.isEmpty) return lastWord;

    int lastIndex = lastWord.toLowerCase().lastIndexOf('e');
    if (lastIndex == -1) return lastWord; // no 'e' found

    String newLast = lastWord.substring(0, lastIndex) + lastWord.substring(lastIndex + 1);
    return swapLastFor(newLast);
  }

  static String firstCharLastWord() {
    if (lastWord.isEmpty) return "";
    return lastWord[0];
  }

   static String firstAmountCharLastWord(int amount) {
    if (lastWord.isEmpty) return "";

    int end = amount > lastWord.length ? lastWord.length : amount;
    return lastWord.substring(0, end);
  }
    
  //
  //PRIMARY GRAMMER FUNCTIONS 
  //

    static String pluralPlus(){
      //finch -> finches, brush -> brushes, cross -> crosses, fox -> foxes, buzz -> buzzes, rhino -> rhinos 
      if (endsWith("ch") || endsWith("sh") 
          || endsWith("s") || endsWith("x") 
          || endsWith("z") || endsWith("o")){
        return appendWord("es ");
      //fairy -> fairies
      } else if (endsWith("y")) {
        return V4rs.message.value = "${deleteLastChar(oldText)}ies ";
      //have -> has
      } else if (endsWith("have")) {
        return V4rs.message.value = "${deleteLastAmount(oldText, 2)}s ";
      //frog -> frogs, boink -> boinks, ect
      } else {
        return appendWord("s ");
      }
    }

    static String comparitiveEr(){
      //funny -> funnier
      if (endsWith("y")) {
        return V4rs.message.value = "${deleteLastChar(oldText)}ier ";
      //working -> worker 
      } else if (endsWith("ing")) {
        V4rs.message.value = oldText.substring(0, oldText.length - 3);
        return comparitiveEr();
      //wise -> wiser
      } else if (endsWith("e")) {
        return appendWord("r ");
      //cruel -> crueller
      } else if (endsWith("cruel")) {
        return appendWord("ler ");
      //up -> upper
      } else if (endsWith("up")) {
        return appendWord("per ");
      //trap -> trapper
      } else if (hasCVCEnding(lastWord)) {
        return V4rs.message.value = "${oldText + lastChar}er ";
      //soft -> softer, teach -> teacher, ect
      } else {
        return V4rs.message.value = "${oldText}er ";
      }
    }
    
    static String adverbMaker() {
      //funny -> funnily
      if (endsWith("y")) {
        return V4rs.message.value = "${deleteLastChar(oldText)}ily ";
      //simple -> simply
      } else if (endsWith("le")) {
        return V4rs.message.value = "${deleteLastChar(oldText)}y ";
      //actual -> actually, quick -> quickly, pixel -> pixelly ect
      } else {
         return appendWord("ly ");
      }
    }

    static String ingSuffix() {
      // die -> dying 
      if (endsWith("ie")) {
        return V4rs.message.value = "${deleteLastAmount(oldText, 2)}ying ";
      // oversee -> overseeing
      } else if (endsWith("see")) {
        return appendWord("ing ");
      //abuse -> abusing
      } else if (endsWith("e")) {
        return V4rs.message.value = "${deleteLastChar(oldText)}ing ";
      //bat -> batting, den -> denning
      } else if (countSyllables(lastWord) == 1 && hasCVCEnding(lastWord)) {
        return appendWord("${lastChar}ing ");
      //widen -> widening
      } else if (hasCVCEnding(lastWord) && (endsWith("en"))) {
        return appendWord("ing ");
      //begin -> beginning
      } else if (hasCVCEnding(lastWord)) {
        return appendWord("${lastChar}ing ");
      //circumvent -> circumventing
      } else {
         return appendWord("ing ");
      }
    }

    static String not() {
      //can -> can't
      if (endsWith("n")) {
        return appendWord("'t ");
      //will -> won't
      } else if (endsWith("will")) {
        return V4rs.message.value = "${deleteLastAmount(oldText, 3)}on't ";
      //should -> shouldn't
      } else {
        return appendWord("n't ");
      }
    }

  static String superlitiveEst(){
    //funny -> funniest
      if (endsWith("y")) {
        return V4rs.message.value = "${deleteLastChar(oldText)}iest ";
      //wise -> wisest
      } else if (endsWith("e")) {
        return appendWord("st ");
      //cruel -> cruellest
      } else if (endsWith("cruel")) {
        return appendWord("lest ");
      //big -> biggest
      } else if (hasCVCEnding(lastWord)) {
        return V4rs.message.value = "${oldText + lastChar}est ";
      //soft -> softest, long -> longest, ect
      } else {
        return V4rs.message.value = "${oldText}est ";
      }
  }

  static String edSuffix(){
    //cry -> cried
    if (endsWith("y") && hasCosonantSecondToLastEnding(lastWord)) {
      return V4rs.message.value = "${deleteLastChar(oldText)}ied ";
    //free -> freed
    } else if (endsWith("e")) {
      return appendWord("d");
    //play -> played
    } else {
      return appendWord("ed");
    }
  }

  static String pastTense(){
    if (endsWith("can")){ return swapLastFor("could");
    } else if (endsWith("see")){ return swapLastFor("saw");
    } else if (endsWith("become")){ return swapLastFor("became");
    } else if (endsWith("come")){ return swapLastFor("came");
    } else if (endsWith("cum")){ return swapLastFor("came");
    } else if (endsWith("do")){ return swapLastFor("did");
    } else if (endsWith("draw")) {return swapLastFor("drew");
    } else if (endsWith("be")){return swapLastFor("was");
    } else if (endsWith("go")){return swapLastFor("went");
    } else if (endsWith("bare")){return swapLastFor("bore");
    } else if (endsWith("swear")){return swapLastFor("swore");
    } else if (endsWith("tear")){return swapLastFor("tore");
    } else if (endsWith("wear")){return swapLastFor("wore");
    } else if (endsWith("go")){return swapLastFor("went");
    } else if (endsWith("blow")){return swapLastFor("blew");
    } else if (endsWith("fly")){return swapLastFor("flew");
    } else if (endsWith("grow")){return swapLastFor("grew");
    } else if (endsWith("know")){return swapLastFor("knew");
    } else if (endsWith("throw")){return swapLastFor("threw");
    } else if (endsWith("begin") || endsWith("drink") 
      || endsWith("ring") || endsWith("run") 
      || endsWith("sing") || endsWith("sink")
      || endsWith("swim") || endsWith("swing")
      || endsWith("sit") || endsWith("sing")) {
        return swapLastVowelForA(lastWord);
    } else if (endsWith("bleed") || endsWith("feed")
      || endsWith("meet") || endsWith("slide")
    ) {
      return deleteLastE(lastWord);
    } else if (endsWith("feel") || endsWith("keep")
      || endsWith("kneel") || endsWith("sleep")
      || endsWith("sweep")
    ) {
      deleteLastE(lastWord);
      return appendWord("t ");
    } else if (endsWith("flee")) {
      return swapLastFor("fled");
    } else if (endsWith("buy") || endsWith("fight") || endsWith("seek")){
      return swapLastFor("${firstCharLastWord()}ought");
    } else if (endsWith("catch") || endsWith("teach")) {
      return swapLastFor("${firstCharLastWord()}aught");
    } else if (endsWith("break")) {return swapLastFor("broke");
    } else if (endsWith("choose")){return swapLastFor("chose");
    } else if (endsWith("freeze")){return swapLastFor("froze");
    } else if (endsWith("speak")) {return swapLastFor("spoke");
    } else if (endsWith("drive")){return swapLastFor("drove");

    } else if (endsWith("ride")){return swapLastFor("rode");
    } else if (endsWith("rise")) {return swapLastFor("rose");
    } else if (endsWith("write")){return swapLastFor("wrote");
    } else if (endsWith("wake")){return swapLastFor("woke");
    } else if (endsWith("dive")) {return swapLastFor("dove");

    } else if (endsWith("bit")){return appendWord("e ");

    } else if (endsWith("eat")){return swapLastFor("ate");
    } else if (endsWith("fall")) {return swapLastFor("fell");
    } else if (endsWith("forget")){return swapLastFor("forgot");
    } else if (endsWith("give")){return swapLastFor("gave");
    } else if (endsWith("hide")) {return swapLastFor("hid");

    } else if (endsWith("shake")){return swapLastFor("shook");
    } else if (endsWith("take")){return swapLastFor("took");
    } else if (endsWith("bend")) {return swapLastFor("bent");
    } else if (endsWith("build")){return swapLastFor("built");
    } else if (endsWith("burn")){return swapLastFor("burnt");

    } else if (endsWith("deal")){return appendWord("t ");

    } else if (endsWith("cling")) {return swapLastFor("clung");
    } else if (endsWith("dig")){return swapLastFor("dug");
    } else if (endsWith("dream")){return swapLastFor("dreamt");
    } else if (endsWith("find")){return swapLastFor("found");
    } else if (endsWith("get")) {return swapLastFor("got");

    } else if (endsWith("hang")){return swapLastFor("hung");
    } else if (endsWith("have")){return swapLastFor("had");
    } else if (endsWith("hear")) {return swapLastFor("heard");
    } else if (endsWith("hold")){return swapLastFor("held");
    } else if (endsWith("lay")){return swapLastFor("laid");

    } else if (endsWith("lead")){return swapLastFor("led");
    } else if (endsWith("leave")){return swapLastFor("left");
    } else if (endsWith("lend")) {return swapLastFor("lent");
    } else if (endsWith("loose")){return swapLastFor("lost");
    } else if (endsWith("make")){return swapLastFor("made");

    } else if (endsWith("mean")){return swapLastFor("meant");
    } else if (endsWith("pay")){return swapLastFor("paid");
    } else if (endsWith("say")) {return swapLastFor("said");
    } else if (endsWith("sell")){return swapLastFor("sold");
    } else if (endsWith("send")){return swapLastFor("sent");

    } else if (endsWith("shoot")){return swapLastFor("shot");
    } else if (endsWith("spell")){return swapLastFor("spelt");
    } else if (endsWith("spend")) {return swapLastFor("spent");
    } else if (endsWith("spin")){return swapLastFor("spun");
    } else if (endsWith("spit")){return swapLastFor("spat");

    } else if (endsWith("stand")){return swapLastFor("stood");
    } else if (endsWith("stick")){return swapLastFor("stuck");
    } else if (endsWith("sting")) {return swapLastFor("stung");
    } else if (endsWith("strike")){return swapLastFor("struck");
    } else if (endsWith("tell")){return swapLastFor("told");

    //cry -> cried
    } else if (endsWith("y")){
      return appendWord("${deleteLastChar(lastWord)}ied ");
    //stop -> stopped
    } else if (countSyllables(lastWord) == 1 && hasCVCEnding(lastWord) && lastChar != "w" && lastChar != "x") {
        return appendWord("${lastChar}ed ");
    //purple -> purpled
    } else if (endsWith("e")){
      return appendWord("d ");
    //fox -> foxed
    } else { 
      return appendWord("ed ");
    }
  }

  static String pastParticiple(){
    if (endsWith("see")){ return swapLastFor("seen");
    } else if (endsWith("do")){ return swapLastFor("done");
    } else if (endsWith("draw")){ return swapLastFor("drawn");
    } else if (endsWith("be")){ return swapLastFor("been");
    } else if (endsWith("prove")){ return swapLastFor("proven");
    } else if (endsWith("go")){ return swapLastFor("gone");
    } else if (endsWith("bare")){ return swapLastFor("born");
    //tear -> torn
    } else if (endsWith("ear")){ return appendWord("${deleteLastAmount(lastWord, 3)}orn ");
    } else if (endsWith("ow")){ return appendWord("n ");
    } else if (endsWith("fly")){ return swapLastFor("flown");
    } else if (endsWith("begin") || endsWith("drink")
      || endsWith("ring") || endsWith("sing") 
      || endsWith("sink") || endsWith("swim") 
      || endsWith("swing")){ 
    return swapLastVowelForU(lastWord);
    } else if (endsWith("bleed") || endsWith("feed")
      || endsWith("meet") || endsWith("slide")){ 
    return deleteLastE(lastWord);
    } else if (endsWith("feel") || endsWith("eep") 
      || endsWith("kneel") || endsWith("slide")){ 
    return appendWord("${deleteLastE(lastWord)}t");
    } else if (endsWith("flee")){ return swapLastFor("fled");
    //buy -> bought
    } else if (endsWith("buy") || endsWith("fight")
      || endsWith("seek")){ 
    return appendWord("${firstCharLastWord}ought ");
    //bring -> brought
    } else if (endsWith("bring") || endsWith("think")){ 
    return appendWord("${firstAmountCharLastWord(2)}ought ");
    //catch -> caught
    } else if (endsWith("catch") || endsWith("teach")){ 
    return appendWord("${firstCharLastWord}aught ");
    //break -> broken
    } else if (endsWith("break") || endsWith("choose")
      || endsWith("freeze") || endsWith("speak")){ 
    return appendWord("${swapFirstTwoVowelForO(lastWord)}en");
    //drive -> driven
    } else if (endsWith("drive") || endsWith("rise")){ 
    return appendWord("n");
    //ride -> ridden 
    } else if (endsWith("ride") || endsWith("write") || endsWith("hide")){ 
      V4rs.message.value = deleteLastChar(lastWord);
    return appendWord("${lastChar}en");
    //wake -> woken
    } else if (endsWith("wake")){ 
    return swapLastFor("woken");
    } else if (endsWith("bite")){ 
    return swapLastFor("bitten");
    } else if (endsWith("eat") || endsWith("fall")){ 
    return appendWord("en");
    } else if (endsWith("forget")){ 
    return swapLastFor("forgotten");
    } else if (endsWith("shake") || endsWith("take") || endsWith("give")){ 
    return appendWord("n");
    } else if (endsWith("bend") || endsWith("build") 
      || endsWith("lend") || endsWith("lose")
      || endsWith("send") || endsWith("spend")){ 
      V4rs.message.value = deleteLastChar(lastWord);
    return appendWord("t");
    } else if (endsWith("burn") || endsWith("deal") 
      || endsWith("dream") || endsWith("mean") 
      || endsWith("spell")){ 
    return appendWord("t");
    } else if (endsWith("cling")){ 

    return swapLastFor("clung");
    //dig -> dug
    } else if (endsWith("dig") || endsWith("hang") 
      || endsWith("stick") || endsWith("sting")){ 
    return swapLastVowelForU(lastWord) ;
    } else if (endsWith("have")){ 
    return swapLastFor("had");
    } else if (endsWith("get")){ 
    return swapLastFor("got");
    } else if (endsWith("hear")){ 
    return appendWord("heard");
    } else if (endsWith("hold")){ 
    return swapLastFor("held");
    } else if (endsWith("lay")){ 
    return swapLastFor("laid");
    } else if (endsWith("lead")){ 
    return swapLastFor("led");
    } else if (endsWith("leave")){ 
    return swapLastFor("left");
    } else if (endsWith("make")){ 
    return swapLastFor("made");
    } else if (endsWith("hold")){ 
    return swapLastFor("held");
    //pay -> paid
    } else if (endsWith("pay") || endsWith("say")){ 
    return appendWord("${deleteLastChar(lastWord)}id");
    } else if (endsWith("sell")){ 
    return swapLastFor("sold");
    } else if (endsWith("shoot")){ 
    return swapLastFor("shot");
    } else if (endsWith("spin")){ 
    return swapLastFor("spun");
    } else if (endsWith("spit")){ 
    return swapLastFor("spat");
    } else if (endsWith("stand")){ 
    return swapLastFor("stood");
    } else if (endsWith("strike")){ 
    return swapLastFor("struck");
    } else if (endsWith("tell")){ 
    return swapLastFor("told");
    //cry -> cried
    } else if (endsWith("y")){
      return appendWord("${deleteLastChar(lastWord)}ied ");
    //stop -> stopped
    } else if (countSyllables(lastWord) == 1 && hasCVCEnding(lastWord) && lastChar != "w" && lastChar != "x") {
        return appendWord("${lastChar}ed ");
    //purple -> purpled
    } else if (endsWith("e")){
      return appendWord("d ");
    //fox -> foxed
    } else { 
      return appendWord("ed ");
    }
  }

  static String tionSuffix(){
    if (endsWith('suspect')) {
      return swapLastFor('suspicion');
    } else if (endsWith("coerce")) {
      return swapLastFor('coersion');
    } else if (endsWith('adapt')) {
      return swapLastFor('adaption');
    } else if (endsWith('tempt')) {
      return swapLastFor('temptation');
    } else if (endsWith('suck')) {
      return swapLastFor('suction');
    } else if (endsWith('dissent')) {
      return swapLastFor('dissention');
    } else if (endsWith('intend')){
      return swapLastFor('intention');
    } else if (endsWith('contend')){
      return swapLastFor('contention');
    } else if (endsWith('decline')){
      return swapLastFor('declination');
    } else if (endsWith('expand')){
      return swapLastFor('expansion');
    } else if (endsWith('vert')){
      return appendWord("${deleteLastChar(lastWord)}sion");
    } else if (endsWith('mit')){
      return appendWord("${deleteLastChar(lastWord)}ssion");
    } else if (endsWith('ct') || endsWith('ate') || endsWith('duce') || endsWith('pt') || endsWith('it') || endsWith('rt')){
      return appendWord("${deleteLastChar(lastWord)}tion");
    } else if (endsWith('ize')){
      return appendWord("${deleteLastChar(lastWord)}ation");
    } else if (endsWith('ify')){
      return appendWord("${deleteLastChar(lastWord)}ication");
    } else if (endsWith('efy')){
      return appendWord("${deleteLastChar(lastWord)}acation");
    } else if (endsWith('aim')){
      return appendWord("${deleteLastAmount(lastWord, 3)}ation");
    } else if (endsWith('ete') || endsWith('ute') || endsWith('ite')){
      return appendWord("${deleteLastChar(lastWord)}ion");
    } else if (endsWith('scribe')){
      return appendWord("${deleteLastAmount(lastWord, 3)}ption");
    } else if (endsWith('ceive')){
      return appendWord("${deleteLastAmount(lastWord, 4)}ption");
    } else if (endsWith('sume')){
      return appendWord("${deleteLastChar(lastWord)}ption");
    } else if (endsWith('olve')){
      return appendWord("${deleteLastAmount(lastWord, 3)}ution");
    } else if (endsWith('ose')){
      return appendWord("${deleteLastChar(lastWord)}ition");
    } else if (endsWith('ise') || endsWith('use')){
      return appendWord("${deleteLastChar(lastWord)}ion");
    } else if (endsWith('pel')){
      return appendWord("${deleteLastAmount(lastWord, 3)}ulsion");
    } else if (endsWith('cede') || endsWith('ss')){
      return appendWord("${deleteLastAmount(lastWord, 3)}ssion");
    } else if (endsWith('tain') || endsWith('vene') || endsWith('vent')){
      return appendWord("${deleteLastAmount(lastWord, 3)}ention");
    } else if (endsWith('end') || endsWith('use')){
      return appendWord("${deleteLastChar(lastWord)}sion");
    } else if ((endsWith('erse') || endsWith('ur') || endsWith('erge'))){
      return appendWord("${deleteLastAmount(lastWord, 3)}rsion");
    } else if (endsWith('de')){
      return appendWord("${deleteLastAmount(lastWord, 3)}sion");
    } else {
      return appendWord('tion');
    }
  }

static String disPrefix() {
  if (startsWith('dis')) { 
    return deleteStartAmount(3);
  } else {
    return appendStartWord('dis');
  }
}

static String unPrefix() {
  if (startsWith('un')) { 
    return deleteStartAmount(2);
  } else {
    return appendStartWord('un');
  }
}

static String ySuffix() {
  if (hasCVCEnding(lastWord)) {
    return appendWord("${lastChar}y ");
  } else { 
    return appendWord("y ");
  }
}

static String ieSuffix() {
  if (hasCVCEnding(lastWord)) {
    return appendWord("${lastChar}ie ");
  } else { 
    return appendWord("ie ");
  }
}

static String amContraction() {
    return appendWord("'m ");
}

static String areContraction() {
    return appendWord("'re ");
}

static String willContraction() {
    return appendWord("'ll ");
}

static String haveContraction() {
    return appendWord("'ve ");
}

static String wouldContraction() {
    return appendWord("'d ");
}

static String posessive() {
    return appendWord("'s ");
}

static String agentNouns() {
  if (endsWith("ad")) { return swapLastFor("advertiser");
  } else if (endsWith("story")) { return swapLastFor("storyteller");
  } else if (endsWith("song")) { return swapLastFor("singer");
  } else if (endsWith("mountain")) { return swapLastFor("mountaineer");
  } else if (endsWith("complaint")) { return swapLastFor("complainer");
  } else if (endsWith("apology")) { return swapLastFor("apologizer");
  } else if (endsWith("thought")) { return swapLastFor("thinker");
  } else if (endsWith("defence")) { return swapLastFor("defender");
  } else if (endsWith("development")) { return swapLastFor("developer");
  } else if (endsWith("announcement")) { return swapLastFor("announcer");
  } else if (endsWith("astronomy")) { return swapLastFor("astronomer");
  } else if (endsWith("explination")) { return swapLastFor("explainer");
  } else if (endsWith("promotion")) { return swapLastFor("promoter");
  } else if (endsWith("diabetes")) { return swapLastFor("diabetic");
  } else if (endsWith("team")) { return swapLastFor("teammate");
  } else if (endsWith("ballet")) { return swapLastFor("ballerina");
  } else if (endsWith("fashion")) { return swapLastFor("fashionista");
  } else if (endsWith("yoga")) { return swapLastFor("yogi");
  } else if (endsWith("massage")) { return swapLastFor("masseuse");
  } else if (endsWith("guidence")) { return swapLastFor("guide");
  } else if (endsWith("criticism")) { return swapLastFor("critic");
  } else if (endsWith("contest")) { return swapLastFor("contestant");
  } else if (endsWith("racism")) { return swapLastFor("racist");
  } else if (endsWith("bell")) { return swapLastFor("bellop");
  } else if (endsWith("marines")) { return swapLastFor("marine");
  } else if (endsWith("exhibit")) { return swapLastFor("exhibitionist");
  } else if (endsWith("flower")) { return swapLastFor("florist");
  } else if (endsWith("language")) { return swapLastFor("linguist");
  } else if (endsWith("tradition")) { return swapLastFor("traditionalist");
  } else if (endsWith("chemistry")) { return swapLastFor("chemist");
  } else if (endsWith("industry")) { return swapLastFor("industrialist");
  } else if (endsWith("beg")) { return swapLastFor("beggar");
  } else if (endsWith("register")) { return swapLastFor("registrar");
  } else if (endsWith("science")) { return swapLastFor("scientist");
  } else if (endsWith("chemical")) { return swapLastFor("chemist");
  } else if (endsWith("critize")) { return swapLastFor("critic");
  } else if (endsWith("represent")) { return swapLastFor("representative");
  } else if (endsWith("participate")) { return swapLastFor("participant");
  } else if (endsWith("comment")) { return swapLastFor("commentator");
  } else if (endsWith("bet")) { return swapLastFor("bettor");
  } else if (endsWith("compete")) { return swapLastFor("competition");
  } else if (endsWith("succeed")) { return swapLastFor("successor");
  } else if (endsWith("investment")) { return swapLastFor("investor");
  } else if (endsWith("improv")) { return swapLastFor("improvisor");
  } else if (endsWith("advice")) { return swapLastFor("advisor");
  } else if (endsWith("note")) { return swapLastFor("notator");
  } else if (endsWith("math")) { return swapLastFor("mathmitician");
  } else if (endsWith("statistic")) { return swapLastFor("statistician");
  } else if (endsWith("politics")) { return swapLastFor("politician");
  } else if (endsWith("poem") || endsWith("poetry")) { return swapLastFor("poet");
  } else if (endsWith("scription")) {
    return V4rs.message.value = '${deleteLastAmount(oldText, lastWord.length)}${firstAmountCharLastWord(3)}scriber';
  } else if (endsWith("magic") || endsWith("music")) { return appendWord("ian");
  } else if (endsWith("trick") || endsWith("prank")) { return appendWord("ster");
  } else if (endsWith("art") || endsWith("cult") || endsWith("color") ||
             endsWith("illusion") || endsWith("violin") || endsWith("behavior") ||
             endsWith("essay") || endsWith("lyric") || endsWith("reception") ||
             endsWith("sew")) {
    return appendWord("ist");
  } else if (endsWith("economy") || endsWith("flute") || endsWith("piano") ||
             endsWith("biology") || endsWith("physics") || endsWith("geology") ||
             endsWith("psychology") || endsWith("anthropology")) {
    return V4rs.message.value = '${deleteLastAmount(oldText, 2)}ist';
  } else if (endsWith("education") || endsWith("objection") || endsWith("instruction") ||
             endsWith("creation") || endsWith("invention") || endsWith("confession") ||
             endsWith("competition") || endsWith("connection") || endsWith("communcation")) {
    return V4rs.message.value = '${deleteLastAmount(oldText, 4)}or ';
  } else if (endsWith("survive") || endsWith("navigate") || endsWith("appreciate") ||
             endsWith("commmunicate") || endsWith("advise") || endsWith("investigate") ||
             endsWith("complicate") || endsWith("motivate") || endsWith("nominate") ||
             endsWith("manipulate") || endsWith("indicate") || endsWith("create")) {
    return V4rs.message.value = '${deleteLastAmount(oldText, 1)}or ';
  } else if (endsWith("debt") || endsWith("visit") || endsWith("sail") || endsWith("object") ||
             endsWith("instruct") || endsWith("suggest") || endsWith("correct") ||
             endsWith("experiment") || endsWith("act") || endsWith("suit") ||
             endsWith("conquer") || endsWith("reflect") || endsWith("distract") ||
             endsWith("predict") || endsWith("attract") || endsWith("invent") ||
             endsWith("conduct") || endsWith("resist") || endsWith("limit") ||
             endsWith("connect")) {
    return appendWord("or");
  } else if (endsWith("inform") || endsWith("consult")) { return appendWord("ant");
  } else if (endsWith("devote") || endsWith("divorce") || endsWith("retire")) { return appendWord("e");
  } else if (endsWith("interveiw") || endsWith("attend") || endsWith("train")) { return appendWord("ee");
  } else if (startsWith("ship")) { return swapLastFor("shipper");
  } else if (endsWith("ship")) { return V4rs.message.value = deleteLastAmount(oldText, 5);
  } else if (endsWith("phobia")) { return appendWord("phobe");
  //er endings
  } else if (endsWith("y")) {
    return V4rs.message.value = "${deleteLastChar(oldText)}ier ";
  } else if (endsWith("ing")) {
    V4rs.message.value = oldText.substring(0, oldText.length - 3);
    return comparitiveEr();
  } else if (endsWith("e")) {
    return appendWord("r ");
  } else if (endsWith("cruel")) {
    return appendWord("ler ");
  } else if (endsWith("up")) {
    return appendWord("per ");
  } else if (hasCVCEnding(lastWord)) {
    return V4rs.message.value = "${oldText + lastChar}er ";
  } else {
    return V4rs.message.value = "${oldText}er ";
  }
}

static String placholder(){
  return V4rs.message.value = V4rs.message.value;
}

static String grammerFunctions(String input){
  switch (input) {
    case 'comparativeEr': 
      return '${comparitiveEr()} ';
    case 'pluralPlus': 
      return '${pluralPlus()} ';
    case 'ingSuffix':
      return ingSuffix();
    case 'adverbMaker': 
      return '${adverbMaker()} ';
    case 'not':
      return '${not()} ';
    case 'superlitiveEst':
      return '${superlitiveEst()} ';
    case 'edSuffix':
      return '${edSuffix()} ';
    case 'pastTense': 
      return '${pastTense()} ';
    case 'pastParticiple':
      return '${pastParticiple()} ';
    case 'tionSuffix':
      return '${tionSuffix()} ';
    case 'disPrefix': 
      return '${disPrefix()} ';
    case 'unPrefix':
      return '${unPrefix()} ';
    case 'ySuffix':
      return '${ySuffix()} ';
    case 'ieSuffix': 
      return '${ieSuffix()} ';
    case 'amContraction':
      return '${amContraction()} ';
    case 'willContraction':
      return '${willContraction()} ';
    case 'haveContraction': 
      return '${haveContraction()} ';
    case 'wouldContraction':
      return '${wouldContraction()} ';
    case 'posessive': 
      return '${posessive()} ';
    case 'agentNouns':
      return '${agentNouns()} ';
    case 'areContraction': 
      return '${areContraction()} ';
    default: 
      return '${placholder()} ';
  }
}

static Map<String, String> grammerFunctionMap = {
  'none': 'placholder',
  'comparative (-er)': 'comparativeEr',
  'plural+': 'pluralPlus',
  '-ing suffix': 'ingSuffix',
  'adverb Maker': 'adverbMaker',
  'not Contraction': 'not',
  'superlitive (-est)': 'superlitiveEst',
  '-ed suffix': 'edSuffix',
  'past tense': 'pastTense',
  'past participle': 'pastParticiple',
  '-tion suffix': 'tionSuffix',
  'dis- prefix': 'disPrefix',
  'un- prefix': 'unPrefix',
  '-y suffix': 'ySuffix',
  '-ie suffix': 'ieSuffix',
  'am contraction': 'amContraction',
  'are contraction': 'areContraction',
  'will contraction': 'willContraction',
  'have contraction': 'haveContraction',
  'would contraction': 'wouldContraction',
  'posessive': 'posessive',
  'agent nouns': 'agentNouns',
};

static List<String> partOfSpeechList = [
  'folder',
  'noun',
  'verb', 
  'adjective', 
  'adverb', 
  'pronoun', 
  'social', 
  'question',
  'conjunction', 
  'determiner',
  'extra 1', 
  'extra 2', 
  'interjection',
  'negation&', 
  'preposition', 
];

}