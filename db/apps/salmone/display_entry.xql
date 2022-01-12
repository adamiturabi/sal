xquery version "3.1";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare function local:get_entry($key as xs:string) as node()+ {
     for $entry in collection('/db/lexica/ara/sal')//entryFree[@key=$key]
     return $entry
};
declare function local:process_verbform1_tenses($formin as node()) {
    for $form in $formin
    return (:"FormI pret: "||fn:normalize-space($form/orth/text())||", ao vowel="||fn:normalize-space($form/itype/text()):)
        <div class="componentWrapper">
            <div class="header">Verb pair</div>
            <div class="componentWrapper">
                <div class="header">Preterite</div>
                {fn:normalize-space($form/orth/text())}
            </div>
            <div class="componentWrapper">
                <div class="header">Aorist</div>
                {fn:normalize-space($form/itype/text())}
            </div>
        </div>
};
declare function local:process_gen_orthform($formin as node()) {
    for $form in $formin
    return (:"Noun: "||fn:normalize-space($form/orth/text()):)
        <div class="componentWrapper">
            <div class="header">Noun</div>
            {fn:normalize-space($form/orth/text())}
        </div>
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
                <span class="badge bg-primary">Preterite:</span>
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
                <span class="badge bg-primary">Preterite:</span>
                {fn:normalize-space($form/orth/text())}
            </span>
        </span>
        <span class="px-2">
            <span class="border border-primary">
                <span class="badge bg-primary">Aorist:</span>
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
            <span class="badge bg-primary">Nouns of action:</span>
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
declare function local:process_form($formin as node()+)
{
    for $form in $formin
    return
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
        <span class="badge bg-primary">Aorist:</span>
        {fn:normalize-space($itype/text())}
    </span>
</span>
};
declare function local:process_inline_masdar($formin as node()+) {
    for $form in $formin
    return
<span class="px-2">
    <span class="border border-primary">
        <span class="badge bg-primary">Nouns of action:</span>
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
        else if (exists($form/mood) and fn:lower-case(fn:normalize-space($form/mood/text()))="n. ac.") then
            local:process_inline_masdar($form/itype)
        else if (exists($form/form)) then
            local:process_inline_form($form/form)
        else()
};
declare function local:process_sense($sense_nodein as node()+) as xs:string* {
    for $sense_node in $sense_nodein/node()
    return
        if (fn:exists($sense_nodein/text())) then
            $sense_node
        else if (fn:exists($sense_nodein/form)) then
            local:process_inline_form($sense_nodein/form)
        else if (fn:exists($sense_node/element())) then 
            local:process_sense($sense_node/node())
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
declare function local:process_entry($entryin as node()) {
    for $entry in $entryin
    return
<div class="card">
    <div class="card-body">
    {local:process_forms($entry)}
        <ol class="list-group list-group-numbered">
    {local:process_senses($entry)}
        </ol>
    </div>
</div>
};
declare function local:process_entries($entries as node()+) {
    for $entry in $entries
    let $cardtitle :=
        if ($entry//form/itype/@type="vowel") then "Form I"
        else if ($entry//form/itype/@type="conj") then "Form "||fn:normalize-space($entry/form/itype/text())
        else "Noun"
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
let $key:= request:get-parameter('key', 'يَسَرَ')
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
{local:process_entries(local:get_entry($key))}
</div>
</body>
</html>

return (
    document{ $html_document} 
)

