# sal
Salmone Dictionary

This repo has been forked from the Alpheios Project. They (and Perseus) digitzed Salmone's Arabic dictionary in XML. My goal is to use that XML data to provide a searchable lookup of roots and entries. I'm using Xquery and eXist-db as implementation. Currently, the Xquery code is very primitive, partly because I want to get something quick and dirty, and partly because I'm new to Xquery. I'm using Bootstrap CSS at the front-end, mostly because I don't want to spend more time than I need to on the frontend right now.

## Changes to the XML

After going through the XML I've realized that I'll need to edit it in some places. This is in the following cases or for the following reasons:

1. Obvious typos/OCR errors.
2. Obvious errors in XML formatting. Sometimes tags are misplaced. In particular `<sense>` tags need editing anytime there is more than one reference, e.g. "see 3(c), 4(a) & (b)". This is placed in one `sense` tag but it needs to be separated into three such tags.
3. Obvious errors in Salmone's text. This is not always easy to figure out but I do think it is obvious in some places. For example, Salmone does not mention اتّخذ for Form VIII and so the default ائْتَخَذَ is assumed. However, I think it is obvious that اتّخذ should be the default. However, once I embark on these changes I'll have to clearly mention that the text has been revised from Salmone's original.
4. I'm also planning to automatically display the text of referenced definitions, or at least hyperlink them, so that the user does not have to retype another search term. I think some XML editing may be required for this.
5. I may tinker with benign punctuation, like commas between entries and definitions, brackets, parentheses. However, I'll respect the meaningful punctuation like comma vs. semi-colon within a definition.
6. Salmone uses transcripted text for prepositions, e.g. ['An & Bi or acc.]. I'll probably substitute arabic text thus : [عن & ب/ه]. I'll need to make sure RTL/bidi is correct. Usually it is quite tricky around brackets and symbols. The XML may not need to be edited for this.
7. I may "fix" Arabic orthography, especially with respect to hamza. Not sure about this...

## SCM and versioning

I don't know yet how to use eXist-db with git. It has its own versioning that is mentioned in its docs. For now I'm using backup/restore or copy-paste for transfering changes between eXist-db and git. Horrible, I know...

I've seen this project (https://github.com/XQueryInstitute/shakespeare-search) which uses `ant` scripts to manage this. I need to study that..

## How to use

1. Install eXist-db
2. Start eXist-db server.
4. Right click on eXist icon in system tray and open eXide IDE (comes with eXist-db).
5. File->Manage
6. Upload `db/lexica/ara/sal/usalmone.xml`. You'll have to create collections to maintain this directory structure.
7. Upload `db/apps/display_entry.xql`
8. In a browser window go to http://localhost:8080/exist/apps/salmone/display_entry.xql?key=%D8%A8%D9%8E%D9%87%D9%8E%D8%A3%D9%8E. Replace the arabic key text in the URL as desired.
