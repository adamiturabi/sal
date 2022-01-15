xquery version "3.1";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare function local:get_entry($key as xs:string) as node()+ {
     for $entry in doc('/db/salmone/salsub.xml')//entryFree[@key=$key]
     return $entry
};
declare function local:get_root($key as xs:string) as node()+ {
     for $entry in doc('/db/salmone/salsub.xml')//div2[@n=$key]/entryFree
     return $entry
};
declare function local:process_genform($formin as node()) {
    for $form in $formin
    return
<div class="card">
    <div class="card-body">
        <span class="px-2">
{
        if (exists($form/orth)) then
            fn:normalize-space($form/orth/text())
        else if (exists($form/form)) then
            local:process_form($form/form)
        else ()
}
        </span> 
    </div>
</div>
};
declare function local:process_formIIplusverb($formin as node()) {
    for $form in $formin
    return
<div class="card">
    <div class="card-body">
        <span class="px-2">
            <span class="border border-primary">
                <span class="badge bg-primary">pret:</span>
                {fn:normalize-space($form/orth/text())}
            </span>
        </span>
    </div>
</div>
};
declare function local:process_formIverb($formin as node()) {
    for $form in $formin
    return
<div class="card">
    <div class="card-body">
        <span class="px-2">
            <span class="border border-primary">
                <span class="badge bg-primary">pret.</span>
                {fn:normalize-space($form/orth/text())}
            </span>
        </span>
        <span class="px-2">
            <span class="border border-primary">
                <span class="badge bg-primary">ao.</span>
                {fn:normalize-space($form/itype/text())}
            </span>
        </span>
{
        if (exists($form/form)) then
            local:process_form($form/form)
        else ()
}
    </div>
</div>
};
declare function local:process_form_list($formin as node()+)
{
    for $form in $formin
    for $form2 in $form/form
    return
        fn:normalize-space($form2/orth/text())
};
declare function local:process_masdars($formin as node()+)
{
    for $form in $formin
    return
<div class="card">
    <div class="card-body">
        <span class="px-2"> <span class="border border-primary">
            <span class="badge bg-primary">n.ac.</span>
{
        if (exists($form/form)) then
            local:process_form_list($form)
        else fn:normalize-space($form/orth/text())
}
            </span>
        </span>
    </div>
</div>
};
declare function local:process_usage_entry_form($formin as element()) {
    for $form in $formin
    return
<span class="d-inline-flex" style="background:#ced4da">
        {$form/orth}
</span>  
};
declare function local:process_formIIplus_form($formin as element()) {
    for $form in $formin
    return
<span class="d-inline-flex" style="background:#ced4da">
        {$form/orth}
</span>  
};
declare function local:process_form($formin as node()+)
{
    for $form in $formin
    return
        (:if (exists($form/orth) and not(exists($form/form)) and not(exists($form/itype))) then
            local:process_usage_entry_form($form)
        else if (exists($form/orth) and exists($form/itype) and $form/itype/@type="conj") then
            local:process_formIIplus_verb_from($form):)
        if (exists($form/mood) and fn:lower-case(fn:normalize-space($form/mood/text()))="n. ac.") then
            local:process_masdars($form)
        else if (exists($form/itype) and $form/itype/@type="vowel") then
            local:process_formIverb($form)
        else if (exists($form/itype) and $form/itype/@type="conj") then
            local:process_formIIplusverb($form)
        else local:process_genform($form)
};
declare function local:process_inline_aorist($itypein as node()+) {
    for $itype in $itypein
    return
<span class="px-2">
    <span class="border border-primary">
        <span class="badge bg-primary">ao.</span>
        {fn:normalize-space($itype/text())}
    </span>
</span>
};
declare function local:process_inline_masdar($formin as node()+) {
    for $form in $formin
    return
<span class="px-2">
    <span class="border border-primary">
        <span class="badge bg-primary">n.ac.</span>
{
        if (exists($form/form)) then
            local:process_form_list($form)
        else fn:normalize-space($form/orth/text())
}
    </span>
</span>
};
declare function local:process_inline_form($formin as node()+) {
    for $form in $formin
    return
        if (fn:exists($form/itype) and $form/itype/@type="vowel") then
            local:process_inline_aorist($form/itype)
        else if (exists($form/mood) or exists($form/number)) then
            local:process_form_list2($form)
        (:else if (exists($form/mood) and fn:lower-case(fn:normalize-space($form/mood/text()))="n. ac.") then
            local:process_inline_masdar($form)
        else if (exists($form/form)) then
            local:process_inline_form($form/form):)
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
        else if (name($x) = "case" and string($x) = "acc.") then
            "ه"
        else $x
};
declare function local:process_xr($xr_in as element()) {
    for $xr in $xr_in
    return
        if (exists($xr/@idref)) then
            string(doc('/db/salmone/salsub.xml')//entryFree[@id=string($xr/@idref)]/sense[@n=string($xr/@refSense)])
        else ()
};
declare function local:process_sense($sense_nodein as node()+) {
    for $x in $sense_nodein/node()
    return
        if ($x instance of text()) then
            $x
        else if (name($x) = "dictScrap") then
            local:process_sense($x)
        else if (name($x) = "form") then
            local:process_inline_form($x)
        else if (name($x) = "usg") then
            <i>{string($x)}</i>
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
        local:process_sense($sense)
}
    </li>
};
declare function local:process_forms($entry as node()) {
    for $form in $entry/form
    return
        local:process_form($form)
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
            return
<li class="list-inline-item"><span class="d-inline px-2" style="background:#ced4da">
{
                if (exists($listitem/itype) and $listitem/itype/@type="vowel") then
                    (string($listitem/itype),
                    if (exists($listitem/orth)) then
                        " ("||string($listitem/orth)||")"
                    else ())
                else if (exists($listitem/orth)) then
                    string($listitem/orth)
                else ()
}
</span></li>
}
</ul>
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
    return
        if (exists($entry/form/form/mood)) then
            local:process_verb_display_card($entry)
        else (
<div class="card">
    <div class="card-body">
        <span class="d-inline-flex">
        "Auto-generate from conjugator"
        </span>
    </div>
</div>
        )
};
declare function local:process_nonverb_entry_form($entry_in as element()) {
    for $entry in $entry_in
    return
<div class="card">
    <div class="card-body">
{
        if (exists($entry/form/orth)) then
            for $orth in $entry/form/orth
            return
        <span class="d-inline-flex p-1 m-1" style="background:#ced4da">{string($orth)}</span>
        else if (exists($entry/form/form/orth)) then
            for $form in $entry/form/form
            return
                if (exists($form/number)) then
                    local:process_form_list2($form)
                else if (exists($form/orth)) then
        <span class="d-inline-flex p-1 m-1" style="background:#ced4da">{string($form/orth)}</span>
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
    let $title_prefix := "Entry: Verb Form "
    let $verb_form_str := fn:normalize-space($entry/form/itype/text())
    let $cardtitle :=
        if ($entry/form/itype/@type="conj") then
            if ($verb_form_str = "Ii" or $verb_form_str = "Iu") then
                $title_prefix || "I"
            else
                $title_prefix || $verb_form_str
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


