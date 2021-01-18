(:~

    Transformation module generated from TEI ODD extensions for processing models.
    ODD: /db/apps/tei-publisher/odd/osinski.odd
 :)
xquery version "3.1";

module namespace model="http://www.tei-c.org/pm/models/osinski/epub";

declare default element namespace "http://www.tei-c.org/ns/1.0";

declare namespace xhtml='http://www.w3.org/1999/xhtml';

declare namespace xi='http://www.w3.org/2001/XInclude';

declare namespace pb='http://teipublisher.com/1.0';

import module namespace css="http://www.tei-c.org/tei-simple/xquery/css";

import module namespace html="http://www.tei-c.org/tei-simple/xquery/functions";

import module namespace epub="http://www.tei-c.org/tei-simple/xquery/functions/epub";

(:~

    Main entry point for the transformation.
    
 :)
declare function model:transform($options as map(*), $input as node()*) {
        
    let $config :=
        map:merge(($options,
            map {
                "output": ["epub","web"],
                "odd": "/db/apps/tei-publisher/odd/osinski.odd",
                "apply": model:apply#2,
                "apply-children": model:apply-children#3
            }
        ))
    
    return (
        html:prepare($config, $input),
    
        let $output := model:apply($config, $input)
        return
            html:finish($config, $output)
    )
};

declare function model:apply($config as map(*), $input as node()*) {
        let $parameters := 
        if (exists($config?parameters)) then $config?parameters else map {}
        let $get := 
        model:source($parameters, ?)
    return
    $input !         (
            let $node := 
                .
            return
                            typeswitch(.)
                    case element(castItem) return
                        (: Insert item, rendered as described in parent list rendition. :)
                        html:listItem($config, ., ("tei-castItem", css:map-rend-to-class(.)), ., ())
                    case element(item) return
                        html:listItem($config, ., ("tei-item", css:map-rend-to-class(.)), ., ())
                    case element(figure) return
                        if (head or @rendition='simple:display') then
                            epub:block($config, ., ("tei-figure1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-figure2", css:map-rend-to-class(.)), .)
                    case element(teiHeader) return
                        if ($parameters?mode='metadata') then
                            epub:block($config, ., ("tei-teiHeader1", css:map-rend-to-class(.)), .)
                        else
                            if ($parameters?header='short') then
                                epub:block($config, ., ("tei-teiHeader4", css:map-rend-to-class(.)), .)
                            else
                                html:metadata($config, ., ("tei-teiHeader5", css:map-rend-to-class(.)), .)
                    case element(supplied) return
                        if (parent::choice) then
                            html:inline($config, ., ("tei-supplied1", css:map-rend-to-class(.)), .)
                        else
                            if (@reason='damage') then
                                html:inline($config, ., ("tei-supplied2", css:map-rend-to-class(.)), .)
                            else
                                if (@reason='illegible' or not(@reason)) then
                                    html:inline($config, ., ("tei-supplied3", css:map-rend-to-class(.)), .)
                                else
                                    if (@reason='omitted') then
                                        html:inline($config, ., ("tei-supplied4", css:map-rend-to-class(.)), .)
                                    else
                                        html:inline($config, ., ("tei-supplied5", css:map-rend-to-class(.)), .)
                    case element(milestone) return
                        html:inline($config, ., ("tei-milestone", css:map-rend-to-class(.)), .)
                    case element(ptr) return
                        if (parent::notatedMusic) then
                            html:webcomponent($config, ., ("tei-ptr", css:map-rend-to-class(.)), ., 'pb-mei', map {"url": @target})
                        else
                            $config?apply($config, ./node())
                    case element(label) return
                        html:inline($config, ., ("tei-label", css:map-rend-to-class(.)), .)
                    case element(signed) return
                        if (parent::closer) then
                            epub:block($config, ., ("tei-signed1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-signed2", css:map-rend-to-class(.)), .)
                    case element(pb) return
                        if (starts-with(@facs, 'iiif:')) then
                            html:webcomponent($config, ., css:get-rendition(., ("tei-pb", "facs", css:map-rend-to-class(.))), @n, 'pb-facs-link', map {"facs": replace(@facs, '^iiif:(.*)$', '$1')})
                        else
                            $config?apply($config, ./node())
                    case element(pc) return
                        html:inline($config, ., ("tei-pc", css:map-rend-to-class(.)), .)
                    case element(anchor) return
                        html:anchor($config, ., ("tei-anchor", css:map-rend-to-class(.)), ., @xml:id)
                    case element(TEI) return
                        html:document($config, ., ("tei-TEI", css:map-rend-to-class(.)), .)
                    case element(formula) return
                        if (@rendition='simple:display') then
                            epub:block($config, ., ("tei-formula1", css:map-rend-to-class(.)), .)
                        else
                            if (@rend='display') then
                                html:webcomponent($config, ., ("tei-formula4", css:map-rend-to-class(.)), ., 'pb-formula', map {"display": true()})
                            else
                                html:webcomponent($config, ., ("tei-formula5", css:map-rend-to-class(.)), ., 'pb-formula', map {})
                    case element(choice) return
                        if (sic and corr) then
                            epub:alternate($config, ., ("tei-choice4", css:map-rend-to-class(.)), ., corr[1], sic[1])
                        else
                            if (abbr and expan) then
                                epub:alternate($config, ., ("tei-choice5", css:map-rend-to-class(.)), ., expan[1], abbr[1])
                            else
                                if (orig and reg) then
                                    epub:alternate($config, ., ("tei-choice6", css:map-rend-to-class(.)), ., reg[1], orig[1])
                                else
                                    $config?apply($config, ./node())
                    case element(hi) return
                        if (@rendition) then
                            html:inline($config, ., css:get-rendition(., ("tei-hi1", css:map-rend-to-class(.))), .)
                        else
                            if (not(@rendition)) then
                                html:inline($config, ., ("tei-hi2", css:map-rend-to-class(.)), .)
                            else
                                $config?apply($config, ./node())
                    case element(code) return
                        html:inline($config, ., ("tei-code", css:map-rend-to-class(.)), .)
                    case element(note) return
                        epub:note($config, ., ("tei-note", css:map-rend-to-class(.)), ., @place, @n)
                    case element(dateline) return
                        epub:block($config, ., ("tei-dateline", css:map-rend-to-class(.)), .)
                    case element(back) return
                        epub:block($config, ., ("tei-back", css:map-rend-to-class(.)), .)
                    case element(del) return
                        html:inline($config, ., ("tei-del", css:map-rend-to-class(.)), .)
                    case element(trailer) return
                        epub:block($config, ., ("tei-trailer", css:map-rend-to-class(.)), .)
                    case element(titlePart) return
                        epub:block($config, ., css:get-rendition(., ("tei-titlePart", css:map-rend-to-class(.))), .)
                    case element(ab) return
                        html:paragraph($config, ., ("tei-ab", css:map-rend-to-class(.)), .)
                    case element(revisionDesc) return
                        html:omit($config, ., ("tei-revisionDesc", css:map-rend-to-class(.)), .)
                    case element(am) return
                        html:inline($config, ., ("tei-am", css:map-rend-to-class(.)), .)
                    case element(subst) return
                        html:inline($config, ., ("tei-subst", css:map-rend-to-class(.)), .)
                    case element(roleDesc) return
                        epub:block($config, ., ("tei-roleDesc", css:map-rend-to-class(.)), .)
                    case element(orig) return
                        html:inline($config, ., ("tei-orig", css:map-rend-to-class(.)), .)
                    case element(opener) return
                        epub:block($config, ., ("tei-opener", css:map-rend-to-class(.)), .)
                    case element(speaker) return
                        epub:block($config, ., ("tei-speaker", css:map-rend-to-class(.)), .)
                    case element(imprimatur) return
                        epub:block($config, ., ("tei-imprimatur", css:map-rend-to-class(.)), .)
                    case element(publisher) return
                        if (ancestor::teiHeader) then
                            (: Omit if located in teiHeader. :)
                            html:omit($config, ., ("tei-publisher", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(figDesc) return
                        html:inline($config, ., ("tei-figDesc", css:map-rend-to-class(.)), .)
                    case element(rs) return
                        html:inline($config, ., ("tei-rs", css:map-rend-to-class(.)), .)
                    case element(foreign) return
                        html:inline($config, ., ("tei-foreign", css:map-rend-to-class(.)), .)
                    case element(fileDesc) return
                        if ($parameters?mode='metadata') then
                            epub:block($config, ., ("tei-fileDesc1", css:map-rend-to-class(.)), .)
                        else
                            if ($parameters?header='short') then
                                (
                                    epub:block($config, ., ("tei-fileDesc2", "header-short", css:map-rend-to-class(.)), titleStmt),
                                    epub:block($config, ., ("tei-fileDesc3", "header-short", css:map-rend-to-class(.)), editionStmt),
                                    epub:block($config, ., ("tei-fileDesc4", "header-short", css:map-rend-to-class(.)), publicationStmt)
                                )

                            else
                                html:title($config, ., ("tei-fileDesc5", css:map-rend-to-class(.)), titleStmt)
                    case element(notatedMusic) return
                        html:figure($config, ., ("tei-notatedMusic", css:map-rend-to-class(.)), ptr, label)
                    case element(seg) return
                        html:inline($config, ., css:get-rendition(., ("tei-seg", css:map-rend-to-class(.))), .)
                    case element(profileDesc) return
                        html:omit($config, ., ("tei-profileDesc", css:map-rend-to-class(.)), .)
                    case element(email) return
                        html:inline($config, ., ("tei-email", css:map-rend-to-class(.)), .)
                    case element(text) return
                        html:body($config, ., ("tei-text", css:map-rend-to-class(.)), .)
                    case element(floatingText) return
                        epub:block($config, ., ("tei-floatingText", css:map-rend-to-class(.)), .)
                    case element(sp) return
                        epub:block($config, ., ("tei-sp", css:map-rend-to-class(.)), .)
                    case element(abbr) return
                        html:inline($config, ., ("tei-abbr", css:map-rend-to-class(.)), .)
                    case element(table) return
                        html:table($config, ., ("tei-table", css:map-rend-to-class(.)), .)
                    case element(cb) return
                        epub:break($config, ., ("tei-cb", css:map-rend-to-class(.)), ., 'column', @n)
                    case element(group) return
                        epub:block($config, ., ("tei-group", css:map-rend-to-class(.)), .)
                    case element(licence) return
                        if (@target) then
                            html:link($config, ., ("tei-licence1", "licence", css:map-rend-to-class(.)), 'Licence', @target, (), map {})
                        else
                            html:omit($config, ., ("tei-licence2", css:map-rend-to-class(.)), .)
                    case element(editor) return
                        if (ancestor::teiHeader) then
                            epub:block($config, ., ("tei-editor1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-editor2", css:map-rend-to-class(.)), .)
                    case element(c) return
                        html:inline($config, ., ("tei-c", css:map-rend-to-class(.)), .)
                    case element(listBibl) return
                        if (bibl) then
                            html:list($config, ., ("tei-listBibl1", css:map-rend-to-class(.)), bibl, ())
                        else
                            epub:block($config, ., ("tei-listBibl2", css:map-rend-to-class(.)), .)
                    case element(address) return
                        epub:block($config, ., ("tei-address", css:map-rend-to-class(.)), .)
                    case element(g) return
                        if (not(text())) then
                            html:glyph($config, ., ("tei-g1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-g2", css:map-rend-to-class(.)), .)
                    case element(author) return
                        if (ancestor::teiHeader) then
                            epub:block($config, ., ("tei-author1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-author2", css:map-rend-to-class(.)), .)
                    case element(castList) return
                        if (child::*) then
                            html:list($config, ., css:get-rendition(., ("tei-castList", css:map-rend-to-class(.))), castItem, ())
                        else
                            $config?apply($config, ./node())
                    case element(l) return
                        epub:block($config, ., css:get-rendition(., ("tei-l", css:map-rend-to-class(.))), .)
                    case element(closer) return
                        epub:block($config, ., ("tei-closer", css:map-rend-to-class(.)), .)
                    case element(rhyme) return
                        html:inline($config, ., ("tei-rhyme", css:map-rend-to-class(.)), .)
                    case element(list) return
                        if (@rendition) then
                            html:list($config, ., css:get-rendition(., ("tei-list1", css:map-rend-to-class(.))), item, ())
                        else
                            if (not(@rendition)) then
                                html:list($config, ., ("tei-list2", css:map-rend-to-class(.)), item, ())
                            else
                                $config?apply($config, ./node())
                    case element(p) return
                        html:paragraph($config, ., css:get-rendition(., ("tei-p", css:map-rend-to-class(.))), .)
                    case element(measure) return
                        html:inline($config, ., ("tei-measure", css:map-rend-to-class(.)), .)
                    case element(q) return
                        if (l) then
                            epub:block($config, ., css:get-rendition(., ("tei-q1", css:map-rend-to-class(.))), .)
                        else
                            if (ancestor::p or ancestor::cell) then
                                html:inline($config, ., css:get-rendition(., ("tei-q2", css:map-rend-to-class(.))), .)
                            else
                                epub:block($config, ., css:get-rendition(., ("tei-q3", css:map-rend-to-class(.))), .)
                    case element(actor) return
                        html:inline($config, ., ("tei-actor", css:map-rend-to-class(.)), .)
                    case element(epigraph) return
                        epub:block($config, ., ("tei-epigraph", css:map-rend-to-class(.)), .)
                    case element(s) return
                        html:inline($config, ., ("tei-s", css:map-rend-to-class(.)), .)
                    case element(docTitle) return
                        epub:block($config, ., css:get-rendition(., ("tei-docTitle", css:map-rend-to-class(.))), .)
                    case element(lb) return
                        epub:break($config, ., css:get-rendition(., ("tei-lb", css:map-rend-to-class(.))), ., 'line', @n)
                    case element(w) return
                        html:inline($config, ., ("tei-w", css:map-rend-to-class(.)), .)
                    case element(stage) return
                        epub:block($config, ., ("tei-stage", css:map-rend-to-class(.)), .)
                    case element(titlePage) return
                        epub:block($config, ., css:get-rendition(., ("tei-titlePage", css:map-rend-to-class(.))), .)
                    case element(name) return
                        html:inline($config, ., ("tei-name", css:map-rend-to-class(.)), .)
                    case element(front) return
                        epub:block($config, ., ("tei-front", css:map-rend-to-class(.)), .)
                    case element(lg) return
                        epub:block($config, ., ("tei-lg", css:map-rend-to-class(.)), .)
                    case element(publicationStmt) return
                        epub:block($config, ., ("tei-publicationStmt1", css:map-rend-to-class(.)), availability/licence)
                    case element(biblScope) return
                        html:inline($config, ., ("tei-biblScope", css:map-rend-to-class(.)), .)
                    case element(desc) return
                        html:inline($config, ., ("tei-desc", css:map-rend-to-class(.)), .)
                    case element(role) return
                        epub:block($config, ., ("tei-role", css:map-rend-to-class(.)), .)
                    case element(docEdition) return
                        html:inline($config, ., ("tei-docEdition", css:map-rend-to-class(.)), .)
                    case element(num) return
                        html:inline($config, ., ("tei-num", css:map-rend-to-class(.)), .)
                    case element(docImprint) return
                        html:inline($config, ., ("tei-docImprint", css:map-rend-to-class(.)), .)
                    case element(postscript) return
                        epub:block($config, ., ("tei-postscript", css:map-rend-to-class(.)), .)
                    case element(edition) return
                        if (ancestor::teiHeader) then
                            epub:block($config, ., ("tei-edition", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(cell) return
                        (: Insert table cell. :)
                        html:cell($config, ., ("tei-cell", css:map-rend-to-class(.)), ., ())
                    case element(relatedItem) return
                        html:inline($config, ., ("tei-relatedItem", css:map-rend-to-class(.)), .)
                    case element(div) return
                        if (@type='title_page') then
                            epub:block($config, ., ("tei-div1", css:map-rend-to-class(.)), .)
                        else
                            if (parent::body or parent::front or parent::back) then
                                html:section($config, ., ("tei-div2", css:map-rend-to-class(.)), .)
                            else
                                epub:block($config, ., ("tei-div3", css:map-rend-to-class(.)), .)
                    case element(graphic) return
                        html:graphic($config, ., ("tei-graphic", css:map-rend-to-class(.)), ., @url, @width, @height, @scale, desc)
                    case element(reg) return
                        html:inline($config, ., ("tei-reg", css:map-rend-to-class(.)), .)
                    case element(ref) return
                        if (parent::cit or parent::def) then
                            (: references (authors) within translations, examples or definitions :)
                            html:inline($config, ., ("tei-ref1", "ref-author", css:map-rend-to-class(.)), .)
                        else
                            if (not(@target)) then
                                html:inline($config, ., ("tei-ref2", css:map-rend-to-class(.)), .)
                            else
                                if (not(node())) then
                                    html:link($config, ., ("tei-ref3", css:map-rend-to-class(.)), @target, @target, (), map {})
                                else
                                    html:link($config, ., ("tei-ref4", css:map-rend-to-class(.)), ., @target, (), map {})
                    case element(pubPlace) return
                        if (ancestor::teiHeader) then
                            (: Omit if located in teiHeader. :)
                            html:omit($config, ., ("tei-pubPlace", css:map-rend-to-class(.)), .)
                        else
                            $config?apply($config, ./node())
                    case element(add) return
                        html:inline($config, ., ("tei-add", css:map-rend-to-class(.)), .)
                    case element(docDate) return
                        html:inline($config, ., ("tei-docDate", css:map-rend-to-class(.)), .)
                    case element(head) return
                        if ($parameters?header='short') then
                            html:inline($config, ., ("tei-head1", css:map-rend-to-class(.)), replace(string-join(.//text()[not(parent::ref)]), '^(.*?)[^\w]*$', '$1'))
                        else
                            if (parent::figure) then
                                epub:block($config, ., ("tei-head2", css:map-rend-to-class(.)), .)
                            else
                                if (parent::table) then
                                    epub:block($config, ., ("tei-head3", css:map-rend-to-class(.)), .)
                                else
                                    if (parent::lg) then
                                        epub:block($config, ., ("tei-head4", css:map-rend-to-class(.)), .)
                                    else
                                        if (parent::list) then
                                            epub:block($config, ., ("tei-head5", css:map-rend-to-class(.)), .)
                                        else
                                            if (parent::div) then
                                                html:heading($config, ., ("tei-head6", css:map-rend-to-class(.)), ., count(ancestor::div))
                                            else
                                                epub:block($config, ., ("tei-head7", css:map-rend-to-class(.)), .)
                    case element(ex) return
                        html:inline($config, ., ("tei-ex", css:map-rend-to-class(.)), .)
                    case element(castGroup) return
                        if (child::*) then
                            (: Insert list. :)
                            html:list($config, ., ("tei-castGroup", css:map-rend-to-class(.)), castItem|castGroup, ())
                        else
                            $config?apply($config, ./node())
                    case element(time) return
                        html:inline($config, ., ("tei-time", css:map-rend-to-class(.)), .)
                    case element(bibl) return
                        if (parent::listBibl) then
                            html:listItem($config, ., ("tei-bibl1", css:map-rend-to-class(.)), ., ())
                        else
                            html:inline($config, ., ("tei-bibl2", css:map-rend-to-class(.)), .)
                    case element(salute) return
                        if (parent::closer) then
                            html:inline($config, ., ("tei-salute1", css:map-rend-to-class(.)), .)
                        else
                            epub:block($config, ., ("tei-salute2", css:map-rend-to-class(.)), .)
                    case element(unclear) return
                        html:inline($config, ., ("tei-unclear", css:map-rend-to-class(.)), .)
                    case element(argument) return
                        epub:block($config, ., ("tei-argument", css:map-rend-to-class(.)), .)
                    case element(date) return
                        if (@when) then
                            epub:alternate($config, ., ("tei-date3", css:map-rend-to-class(.)), ., ., @when)
                        else
                            if (text()) then
                                html:inline($config, ., ("tei-date4", css:map-rend-to-class(.)), .)
                            else
                                $config?apply($config, ./node())
                    case element(title) return
                        if ($parameters?mode='metadata') then
                            html:omit($config, ., ("tei-title1", css:map-rend-to-class(.)), .)
                        else
                            if ($parameters?header='short') then
                                html:heading($config, ., ("tei-title2", css:map-rend-to-class(.)), ., 5)
                            else
                                if (parent::titleStmt/parent::fileDesc) then
                                    (
                                        if (preceding-sibling::title) then
                                            html:text($config, ., ("tei-title3", css:map-rend-to-class(.)), ' — ')
                                        else
                                            (),
                                        html:inline($config, ., ("tei-title4", "foo", css:map-rend-to-class(.)), .)
                                    )

                                else
                                    if (not(@level) and parent::bibl) then
                                        html:inline($config, ., ("tei-title5", css:map-rend-to-class(.)), .)
                                    else
                                        if (@level='m' or not(@level)) then
                                            (
                                                html:inline($config, ., ("tei-title6", css:map-rend-to-class(.)), .),
                                                if (ancestor::biblFull) then
                                                    html:text($config, ., ("tei-title7", css:map-rend-to-class(.)), ', ')
                                                else
                                                    ()
                                            )

                                        else
                                            if (@level='s' or @level='j') then
                                                (
                                                    html:inline($config, ., ("tei-title8", css:map-rend-to-class(.)), .),
                                                    if (following-sibling::* and     (  ancestor::biblFull)) then
                                                        html:text($config, ., ("tei-title9", css:map-rend-to-class(.)), ', ')
                                                    else
                                                        ()
                                                )

                                            else
                                                if (@level='u' or @level='a') then
                                                    (
                                                        html:inline($config, ., ("tei-title10", css:map-rend-to-class(.)), .),
                                                        if (following-sibling::* and     (    ancestor::biblFull)) then
                                                            html:text($config, ., ("tei-title11", css:map-rend-to-class(.)), '. ')
                                                        else
                                                            ()
                                                    )

                                                else
                                                    html:inline($config, ., ("tei-title12", css:map-rend-to-class(.)), .)
                    case element(corr) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            (: simple inline, if in parent choice. :)
                            html:inline($config, ., ("tei-corr1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-corr2", css:map-rend-to-class(.)), .)
                    case element(cit) return
                        if (@type='example') then
                            epub:block($config, ., ("tei-cit1", "example", css:map-rend-to-class(.)), .)
                        else
                            if (@type='translation') then
                                epub:block($config, ., ("tei-cit2", "translation", css:map-rend-to-class(.)), .)
                            else
                                $config?apply($config, ./node())
                    case element(titleStmt) return
                        if ($parameters?mode='title' ) then
                            (
                                html:inline($config, ., ("tei-titleStmt3", css:map-rend-to-class(.)), title[1]),
                                html:inline($config, ., ("tei-titleStmt4", css:map-rend-to-class(.)), subsequence(title, 2))
                            )

                        else
                            if ($parameters?mode='metadata') then
                                epub:block($config, ., ("tei-titleStmt5", css:map-rend-to-class(.)), .)
                            else
                                if ($parameters?header='short') then
                                    (
                                        html:link($config, ., ("tei-titleStmt6", css:map-rend-to-class(.)), title[1], $parameters?doc, (), map {}),
                                        epub:block($config, ., ("tei-titleStmt7", css:map-rend-to-class(.)), subsequence(title, 2)),
                                        epub:block($config, ., ("tei-titleStmt8", css:map-rend-to-class(.)), (author, editor))
                                    )

                                else
                                    epub:block($config, ., ("tei-titleStmt9", css:map-rend-to-class(.)), .)
                    case element(sic) return
                        if (parent::choice and count(parent::*/*) gt 1) then
                            html:inline($config, ., ("tei-sic1", css:map-rend-to-class(.)), .)
                        else
                            html:inline($config, ., ("tei-sic2", css:map-rend-to-class(.)), .)
                    case element(expan) return
                        html:inline($config, ., ("tei-expan", css:map-rend-to-class(.)), .)
                    case element(body) return
                        (
                            html:index($config, ., ("tei-body1", css:map-rend-to-class(.)), 'toc', .),
                            epub:block($config, ., ("tei-body2", css:map-rend-to-class(.)), .)
                        )

                    case element(spGrp) return
                        epub:block($config, ., ("tei-spGrp", css:map-rend-to-class(.)), .)
                    case element(fw) return
                        if (ancestor::p or ancestor::ab) then
                            html:inline($config, ., ("tei-fw1", css:map-rend-to-class(.)), .)
                        else
                            epub:block($config, ., ("tei-fw2", css:map-rend-to-class(.)), .)
                    case element(encodingDesc) return
                        html:omit($config, ., ("tei-encodingDesc", css:map-rend-to-class(.)), .)
                    case element(addrLine) return
                        epub:block($config, ., ("tei-addrLine", css:map-rend-to-class(.)), .)
                    case element(gap) return
                        if (desc) then
                            html:inline($config, ., ("tei-gap1", css:map-rend-to-class(.)), .)
                        else
                            if (@extent) then
                                html:inline($config, ., ("tei-gap2", css:map-rend-to-class(.)), @extent)
                            else
                                html:inline($config, ., ("tei-gap3", css:map-rend-to-class(.)), .)
                    case element(quote) return
                        if (ancestor::cit) then
                            (: quotes within cit should be treated as inline, cit is the block unit :)
                            html:inline($config, ., ("tei-quote1", css:map-rend-to-class(.)), .)
                        else
                            if (ancestor::p) then
                                (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                                html:inline($config, ., css:get-rendition(., ("tei-quote2", css:map-rend-to-class(.))), .)
                            else
                                (: If it is inside a paragraph then it is inline, otherwise it is block level :)
                                epub:block($config, ., css:get-rendition(., ("tei-quote3", css:map-rend-to-class(.))), .)
                    case element(row) return
                        if (@role='label') then
                            html:row($config, ., ("tei-row1", css:map-rend-to-class(.)), .)
                        else
                            (: Insert table row. :)
                            html:row($config, ., ("tei-row2", css:map-rend-to-class(.)), .)
                    case element(docAuthor) return
                        html:inline($config, ., ("tei-docAuthor", css:map-rend-to-class(.)), .)
                    case element(byline) return
                        epub:block($config, ., ("tei-byline", css:map-rend-to-class(.)), .)
                    case element(entryFree) return
                        epub:block($config, ., ("tei-entryFree", css:map-rend-to-class(.)), .)
                    case element(form) return
                        if (starts-with(@facs, 'iiif:')) then
                            html:webcomponent($config, ., ("tei-form", "facs", "columnbreak", css:map-rend-to-class(.)), ., 'pb-facs-link', map {"facs": replace(@facs, '^iiif:([^/]+).*$', '$1'), "coordinates": ('[' || replace(@facs, '^iiif:[^/]+/(.*)$', '$1') || ']'), "emit": 'transcription'})
                        else
                            $config?apply($config, ./node())
                    case element(gram) return
                        html:inline($config, ., ("tei-gram", css:map-rend-to-class(.)), .)
                    case element(oRef) return
                        (: marker for headword reference; rendered as dash :)
                        html:inline($config, ., ("tei-oRef", css:map-rend-to-class(.)), .)
                    case element(gen) return
                        epub:alternate($config, ., ("tei-gen", css:map-rend-to-class(.)), ., ., @norm)
                    case element(pos) return
                        epub:alternate($config, ., ("tei-pos", css:map-rend-to-class(.)), ., ., @norm)
                    case element(msDesc) return
                        (
                            (: retrieves the primary language :)
                            epub:block($config, ., ("tei-msDesc1", css:map-rend-to-class(.)), (root(.)//langUsage/language)),
                            (: retrieves the form of the source from taxonomy file :)
                            epub:block($config, ., ("tei-msDesc2", css:map-rend-to-class(.)), id(substring-after(root(.)//catRef[@scheme='#form']/@target, '#'), doc('/db/apps/tei-publisher/data/taxonomy.xml'))),
                            epub:block($config, ., ("tei-msDesc3", css:map-rend-to-class(.)), .)
                        )

                    case element(institution) return
                        html:inline($config, ., ("tei-institution", css:map-rend-to-class(.)), .)
                    case element(respStmt) return
                        epub:alternate($config, ., ("tei-respStmt", css:map-rend-to-class(.)), ., persName, resp)
                    case element(idno) return
                        (
                            html:inline($config, ., ("tei-idno1", css:map-rend-to-class(.)), .),
                            html:inline($config, ., ("tei-idno2", css:map-rend-to-class(.)), ancestor::msDesc/@type)
                        )

                    case element(exist:match) return
                        html:match($config, ., .)
                    case element() return
                        if (namespace-uri(.) = 'http://www.tei-c.org/ns/1.0') then
                            $config?apply($config, ./node())
                        else
                            .
                    case text() | xs:anyAtomicType return
                        html:escapeChars(.)
                    default return 
                        $config?apply($config, ./node())

        )

};

declare function model:apply-children($config as map(*), $node as element(), $content as item()*) {
        
    if ($config?template) then
        $content
    else
        $content ! (
            typeswitch(.)
                case element() return
                    if (. is $node) then
                        $config?apply($config, ./node())
                    else
                        $config?apply($config, .)
                default return
                    html:escapeChars(.)
        )
};

declare function model:source($parameters as map(*), $elem as element()) {
        
    let $id := $elem/@exist:id
    return
        if ($id and $parameters?root) then
            util:node-by-id($parameters?root, $id)
        else
            $elem
};

