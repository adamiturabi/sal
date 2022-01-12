# sal
Salmone Dictionary

This repo has been forked from the Alpheios Project. They (and Perseus) digitzed Salmone's Arabic dictionary in XML. My goal is to use that XML data to provide a searchable lookup of roots and entries. I'm using Xquery and eXist-db as implementation. Currently, the Xquery code is very primitive, partly because I want to get something quick and dirty, and partly because I'm new to Xquery. I'm using Bootstrap CSS at the front-end, mostly because I don't want to spend more time than I need to on the frontend right now.

## Changes to the XML

After going through the XML I've realized that I'll need to edit it in some places. This is in the following cases or for the following reasons:

1. Obvious typos/OCR errors.
2. Obvious errors in XML formatting: Sometimes tags are misplaced.
   a. In particular `<sense>` tags need editing anytime, there is more than one reference, e.g. "see 3(c), 4(a) & (b)". This is placed in one `sense` tag but it needs to be separated into three such tags.
3. Obvious errors in Salmone's text. This is not easy to figure out but I do think it is obvious in some places. For example, Salmone does not mention اتّخذ for Form VIII and so the default ائْتَخَذَ is assumed. However, I think it is obvious that اتّخذ should be the default.
4. I'm also planning to automatically display the text of referenced definitions, or atleast hyperlink them, so that the reader does not have to retype another search term. I think some XML editing may be required for this.
5. I may tinker with benign punctuation, like commas between entries and definitions, brackets, parentheses. However, I'll respect the meaningful punctuation like comma vs. semi-colon within a definition.
6. Salmone uses transcripted text for prepositions, e.g. ['An & Bi or acc.]. I'll probably substitute arabic text thus : [عن & ب/ه]. I'll need sure RTL/bidi is correct. Usually it is quite tricky around brackets and symbols. The XML may not need to be edited for this.
7. I may "fix" Arabic orthography, especially with respect to hamza. Not sure about this...
