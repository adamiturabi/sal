xquery version "3.1";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";
(:  :import module namespace arabverbconj_namespace="http://exist-db.org/xquery/arabverbconj"
    :at "java:org.exist.xquery.modules.arabverbconj.ArabicVerbConjugatorModule";
:)
import module namespace commonfunc_namespace="http://exist-db.org/xquery/commonfunc"
at "java:org.exist.xquery.modules.commonfunc.CommonFuncModule";

declare function local:get_entry($key as xs:string) as node()+ {
     for $entry in doc('/db/lexica/ara/sal/usalmone_edited.xml')//entryFree[@key=$key]
     return $entry
};
declare function local:get_root($key as xs:string) as node()+ {
     for $entry in doc('/db/lexica/ara/sal/usalmone_edited.xml')//div2[@n=$key]/entryFree
     return $entry
};
declare function local:process_inline_form($formin as node()+) {
    for $form in $formin
    return
        (:
        if (fn:exists($form/itype) and $form/itype/@type="vowel") then
            local:process_inline_aorist($form/itype)
            :)
        if (exists($form/mood) or exists($form/number)) then
            local:process_form_list2($form)
        else()
};

declare function local:process_subc($subc as element()) {
    for $x in $subc/node()
    return
        if ($x = "Bi") then
            "ب"
        else if ($x = "La") then
            "ل"
        else if ($x = "Ila") then
            "إلى"
        else if ($x = "'An") then
            "عن"
        else if ($x = "'Ala") then
            "على" 
        else if ($x = "Min") then
            "من"
        else if ($x = "Fi") then
            "في"
        else if ($x = "Bayn") then
            "بين"
        else $x
};
declare function local:process_gramGrp($gramGrp_in as element()) {
    for $x in $gramGrp_in/node()
    return
        if ($x instance of text()) then
            $x
        else if (name($x) = "subc") then
            local:process_subc($x)
        else if (name($x) = "gram") then
            <i>{string($x)}</i>
        else if (name($x) = "colloc") then
            <i>{string($x)}</i>
        else if (name($x) = "case" and string($x) = "acc.") then
            "ه"
        else $x
};
declare function local:process_foreign($x_in as element()) {
    for $x in $x_in
    return
        if (string($x/@lang) = "xlar") then
            <b>{string($x)}</b>
        else if (string($x/@lang) = "ar") then
            string($x)
        else $x
};
declare function local:process_def($def_in as element()) {
    for $x in $def_in/node()
    return
        if ($x instance of text()) then
            <i>{$x}</i>
        else if (name($x) = "foreign") then
            local:process_foreign($x)
        else $x
};
declare function local:display_xr_ref_text($xin as element(), $do_repl as xs:boolean) {
    for $x in $xin
    let $text := if ($do_repl) then fn:replace(string($x), 'see', 'ref.') else string($x)
    return <span class="d-inline px-2" style="background:#e9ecef"><i>{$text}</i></span>
};
declare function local:get_xref_sense($xr_in as element()) {
    for $xr in $xr_in
    let $xreftokens := fn:tokenize($xr/ref/text(), ' ')
    let $xreftokensfirstchar := fn:substring($xreftokens[1],1,1)
    let $senseidx := if (fn:count($xreftokens) = 1) then "a" else fn:substring($xreftokens[2], 2, 1)
    return 
        if ($xreftokensfirstchar = "I" or $xreftokensfirstchar = "V" or $xreftokensfirstchar = "X") then
            for $entry in $xr/ancestor::div2//entryFree
            where $entry/form/itype[text()=$xreftokens[1]]
            return (local:process_sense($entry/sense[@n=$senseidx], true()), local:display_xr_ref_text($xr, true()))
        else
            for $entry in $xr/ancestor::div2//entryFree
            where $entry/form/form/itype[text()=$xreftokens[1]]
            return (local:process_sense($entry/sense[@n=$senseidx], true()), local:display_xr_ref_text($xr, true()))
};
declare function local:linktoroot($linked_root as xs:string, $xr_text as xs:string) {
    for $root in $linked_root
    for $text in $xr_text
    let $link := "http://localhost:8080/exist/rest/db/salmone/display_entry2.xql?key="||$root
    return
        <a href="{$link}">{$text}</a>
};
declare function local:process_xr($xr_in as element()) {
    for $xr in $xr_in
    let $xr_text := local:display_xr_ref_text($xr, false())
    let $linked_root := $xr/@idref
    (:let $link := "http://localhost:8080/exist/rest/db/salmone/display_entry2.xql?key="||$linked_root:)
    return
        if (exists($xr/@idref)) then
            if (fn:substring($xr/@idref,1,1) = 'n') then
                (string(doc('/db/lexica/ara/sal/usalmone_edited.xml')//entryFree[@id=string($xr/@idref)]/sense[@n=string($xr/@refSense)]), $xr_text)
            else local:linktoroot($linked_root, $xr_text)
        else local:get_xref_sense($xr)
};
declare function local:process_sense($sense_nodein as node()*, $dont_process_form as xs:boolean) {
    for $x in $sense_nodein/node()
    return
        if ($x instance of text()) then
            $x
        else if (name($x) = "dictScrap") then
            local:process_sense($x, $dont_process_form)
        else if (name($x) = "form" and not($dont_process_form)) then
            local:process_inline_form($x)
        else if (name($x) = "usg") then
            <i>{string($x)}</i>
        else if (name($x) = "def") then
            local:process_def($x)
        else if (name($x) = "foreign") then
            local:process_foreign($x)
        else if (name($x) = "gramGrp") then
            local:process_gramGrp($x)
        else if (name($x) = "xr") then
            local:process_xr($x)
        else ()
};
declare function local:process_senses($entry as node()) {
    for $sense in $entry/sense
    return
    <li class="list-group-item">
{
        local:process_sense($sense, false())
}
    </li>
};
declare function local:process_form_list2($formin as element()) {
    for $form in $formin
    return 
<span class="d-inline-flex mx-1">
<ul class="list-inline p-1 m-0" style="background:#e9ecef">
<li class="list-inline-item"><span class="badge me-2 bg-secondary">
{
        if (exists($form/mood)) then
            string($form/mood)
        else if (exists($form/number)) then
            string($form/number)
        else ()
}
</span></li>
{
        for $listitem in $form/form
        let $div2 := $form/ancestor::div2
        let $verbroot := $div2/@n
            return
<li class="list-inline-item"><span class="d-inline px-2" style="background:#ced4da">
{
                if (exists($listitem/itype) and not(exists($listitem/orth))) then
                    if (string($form/mood) = "pret.") then (
                        if ($listitem/itype/@type="vowel") then (
                            (: verb form I :)
                            local:display_orth(commonfunc_namespace:commonfunc(("conj", $verbroot, "I", "0", fn:lower-case(string($listitem/itype)))))
                        ) else (
                            (: verb form II+ :)
                            local:display_orth(commonfunc_namespace:commonfunc(("conj", $verbroot, string($listitem/itype), "0", "a")))
                        )
                    ) else if (string($form/mood) = "ao.") then (
                        if ($listitem/itype/@type="vowel") then (
                            (: verb form I :)
                            local:display_orth(commonfunc_namespace:commonfunc(("conj", $verbroot, "I", "1", fn:lower-case(string($listitem/itype)))))
                        ) else (
                            (: verb form II+ :)
                            local:display_orth(commonfunc_namespace:commonfunc(("conj", $verbroot, string($listitem/itype), "1", "a")))
                        )
                    ) else ()
                    (:
                if (exists($listitem/itype) and $listitem/itype/@type="vowel") then
                    (fn:lower-case(string($listitem/itype)),
                    if (exists($listitem/orth)) then
                        " ("||string($listitem/orth)||")"
                    else ())
                    :)
                else if (exists($listitem/orth)) then
                    local:display_orth(string($listitem/orth))
                else ()
}
</span>{local:show_edited($listitem)}</li>
}
</ul>
</span>
};
declare function local:display_orth($orth_in as xs:string) {
    for $orth in $orth_in
    return
<span lang="ar" dir="rtl" style="font-family:Vazir;" class="artext">
{
        string($orth)
}
</span>
};
declare function local:process_verb_display_card($entry as element()) {
    for $form in $entry/form
    where exists($form/form/mood)
    return
<div class="card">
    <div class="card-body">
{
        for $listform in $form/form
        return
            local:process_form_list2($listform)
}
    </div>
</div>
};
declare function local:process_verb_entry_forms($entry_in as element()) {
    for $entry in $entry_in
    let $div2 := $entry/ancestor::div2
    let $verbroot := $div2/@n
    return
        if (exists($entry/form/form/mood)) then
            local:process_verb_display_card($entry)
        else (
            for $form in $entry/form
            let $verbform := string($form/itype/text())
            return
<div class="card">
    <div class="card-body">
        <span class="d-inline-flex mx-1">
            <ul class="list-inline p-1 m-0" style="background:#e9ecef">
                <li class="list-inline-item"><span class="badge me-2 bg-secondary">{"pret."}</span></li>
                <li class="list-inline-item"><span class="d-inline px-2" style="background:#ced4da">
            {local:display_orth(commonfunc_namespace:commonfunc(("conj", $verbroot, $verbform, "0", "a")))}
                </span></li>
            </ul>
        </span>
        <span class="d-inline-flex mx-1">
            <ul class="list-inline p-1 m-0" style="background:#e9ecef">
                <li class="list-inline-item"><span class="badge me-2 bg-secondary">{"ao."}</span></li>
                <li class="list-inline-item"><span class="d-inline px-2" style="background:#ced4da">
            {local:display_orth(commonfunc_namespace:commonfunc(("conj", $verbroot, $verbform, "1", "a")))}
                </span></li>
            </ul>
        </span>
    </div>
</div>
        )
};
declare function local:show_edited($form_in as element()) {
    for $form in $form_in
    return if (exists($form/err)) then <sup>*</sup> else ()
};
declare function local:process_nonverb_entry_form($entry_in as element()) {
    for $entry in $entry_in
    return
<div class="card">
    <div class="card-body">
{
        if (exists($entry/form/orth)) then
            for $form in $entry/form
            let $lang := if (exists($form/lang)) then " ("||string($form/lang)||")" else ""
            let $err := if (exists($form/err)) then "<sup>*</sup>" else ""
            return
        (<span class="d-inline-flex p-1 m-1" style="background:#ced4da; font-family:Vazir;">{string($form/orth)||$lang}</span>,local:show_edited($form))
        else if (exists($entry/form/form/orth)) then
            for $form in $entry/form/form
            let $lang := if (exists($form/lang)) then " ("||string($form/lang)||")" else ""
            let $err := if (exists($form/err)) then "<sup>*</sup>" else ""
            return
                if (exists($form/number)) then
                    local:process_form_list2($form)
                else if (exists($form/orth)) then
        (<span class="d-inline-flex p-1 m-1" style="background:#ced4da; font-family:Vazir;">{string($form/orth)||$lang}</span>,local:show_edited($form))
                else ()
        else()
}
    </div>
</div>
};
declare function local:process_entry($entryin as element()) {
    for $entry in $entryin
    return (
        if (exists($entry/form/itype) and $entry/form/itype/@type="conj") then
            local:process_verb_entry_forms($entry)
        else
            local:process_nonverb_entry_form($entry)
        ,<ol class="list-group list-group-numbered">
    {local:process_senses($entry)}
        </ol>
    )
};
declare function local:process_entries($entries as node()+) {
    for $entry in $entries
    (:let $title_prefix := "Entry: Verb Form "
    let $verb_form_str := fn:normalize-space($entry/form/itype/text()):)
    let $cardtitle :=
        if ($entry/form/itype/@type="conj") then
            ("Entry: Verb Form",
            for $form at $position in $entry/form
            let $last := count($entry/form)
            let $comma := if ($position ne $last) then ", " else ""
            return string($form/itype)||$comma)
            (:$title_prefix || $verb_form_str:)
        else if (exists($entry/form/form/itype)) then
            ("Entry "||string($entry/form/mood)||" ",
            for $itype at $position in $entry/form/form/itype
            let $last := count($entry/form/form/itype)
            let $comma := if ($position ne $last) then ", " else ""
            return string($itype)||$comma)
        else "Entry"
    return
<div class="card">
    <div class="card-body">
    <h5 class="card-title">{$cardtitle}</h5>
    {
        local:process_entry($entry)
    }
    </div>
</div>
};

(:  :local:process_entries(local:get_entry("bahaA^a")):)
let $key:= request:get-parameter('key', 'يسر')
let $html_document :=
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8"></meta>
    <meta name="viewport" content="width=device-width, initial-scale=1"></meta>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous"></link>
  <style>
    li.list-group-item::before {{
        content: counter(section, lower-latin) ". ";
    }}
    artext {{
        fon-family: Vazir;
    }}
  </style>

    <title>Salmone's Arabic Dictionary</title>
  </head>
  <body>
    <h1>Salmone's Arabic Dictionary</h1>
    <!-- Optional JavaScript; choose one of the two! -->

    <!-- Option 1: Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

    <!-- Option 2: Separate Popper and Bootstrap JS -->
    <!--
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-7+zCNj/IqJ95wo16oMtfsKbZ9ccEh31eOz1HGyDuCQ6wgnyJNSYdrPa03rtR1zdB" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
    -->
<div class="container">
    <div class="row">
        <div class="col">
{local:process_entries(local:get_root($key))}
        </div>
    </div>
</div>
</body>
</html>

return (
    document{ $html_document} 
)


