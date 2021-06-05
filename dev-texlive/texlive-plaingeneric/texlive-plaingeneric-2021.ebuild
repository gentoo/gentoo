# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="abbr abstyles apnum autoaligne barr bitelist borceux c-pascal catcodes chronosys colorsep compare cweb-old dinat dirtree docbytex dowith eijkhout encxvlna epigram epsf epsf-dvipdfmx expkv expkv-cs expkv-def expkv-opt fenixpar figflow fixpdfmag fltpoint fntproof font-change fontch fontname gates getoptk gfnotation gobble graphics-pln gtl hlist hyplain insbox js-misc kastrup lambda-lists langcode lecturer letterspacing librarian listofitems localloc mathdots metatex midnight mkpattern modulus multido namedef navigator newsletr nth ofs olsak-misc outerhbox path pdf-trans pitex placeins-plain plainpkg plipsum plnfss plstmary poormanlog present pwebmac random randomlist resumemac ruler schemata shade simplekv soul swrule systeme tabto-generic termmenu tex-ps tex4ht texapi texdate texinfo timetable tracklang treetex trigonometry ulem upca varisize xii xii-lat xlop yax zztex collection-plaingeneric
"
TEXLIVE_MODULE_DOC_CONTENTS="abbr.doc abstyles.doc apnum.doc autoaligne.doc barr.doc bitelist.doc borceux.doc c-pascal.doc catcodes.doc chronosys.doc dinat.doc dirtree.doc docbytex.doc dowith.doc encxvlna.doc epsf.doc epsf-dvipdfmx.doc expkv.doc expkv-cs.doc expkv-def.doc expkv-opt.doc fenixpar.doc figflow.doc fltpoint.doc fntproof.doc font-change.doc fontch.doc fontname.doc gates.doc getoptk.doc gfnotation.doc gobble.doc graphics-pln.doc gtl.doc hlist.doc hyplain.doc insbox.doc js-misc.doc kastrup.doc lambda-lists.doc langcode.doc lecturer.doc librarian.doc listofitems.doc localloc.doc mathdots.doc metatex.doc midnight.doc mkpattern.doc modulus.doc multido.doc namedef.doc navigator.doc newsletr.doc ofs.doc olsak-misc.doc path.doc pdf-trans.doc pitex.doc plainpkg.doc plipsum.doc plnfss.doc plstmary.doc poormanlog.doc present.doc pwebmac.doc random.doc randomlist.doc resumemac.doc schemata.doc shade.doc simplekv.doc soul.doc systeme.doc termmenu.doc tex-ps.doc tex4ht.doc texapi.doc texdate.doc tracklang.doc treetex.doc trigonometry.doc ulem.doc upca.doc varisize.doc xii.doc xii-lat.doc xlop.doc yax.doc zztex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="bitelist.source catcodes.source dirtree.source dowith.source expkv.source expkv-cs.source expkv-def.source expkv-opt.source fltpoint.source gobble.source gtl.source kastrup.source langcode.source localloc.source mathdots.source modulus.source multido.source namedef.source plainpkg.source randomlist.source schemata.source soul.source termmenu.source texdate.source tracklang.source "
inherit  texlive-module
DESCRIPTION="TeXLive Plain (La)TeX packages"

LICENSE=" GPL-1 GPL-2 GPL-3 LPPL-1.3 LPPL-1.3c MIT public-domain TeX TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2021
>=dev-texlive/texlive-basic-2019
!dev-texlive/texlive-genericextra
!dev-texlive/texlive-genericrecommended
!dev-texlive/texlive-plainextra
"
RDEPEND="${DEPEND} "
