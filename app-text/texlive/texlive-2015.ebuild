# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cjk context detex dvi2tty extra epspdf games graphics
humanities jadetex luatex metapost music omega pdfannotextractor png pstricks publishers
science tex4ht texi2html truetype xetex xindy xml X"

LANGS="af ar as bg bn br ca cs cy da de el en en_GB eo es et eu fa fi fr ga gl
	gu he hi hr hsb hu hy ia id is it ja ko kn la lo lt lv ml mn mr nb nl nn no
	or pa pl pt rm ro ru sa_IN sco sk sl sq sr sv ta te th tk tr uk vi zh"

for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done

TEXLIVE_CAT="dev-texlive"

DEPEND=">=app-text/texlive-core-${PV}"
RDEPEND="${DEPEND}
	app-text/psutils
	>=${TEXLIVE_CAT}/texlive-fontutils-${PV}
	media-gfx/sam2p
	texi2html? ( app-text/texi2html )
	sys-apps/texinfo
	app-text/t1utils
	>=app-text/lcdf-typetools-2.92[kpathsea]
	truetype? ( >=app-text/ttf2pk2-2.0_p20150521 )
	detex? ( dev-tex/detex )
	app-text/ps2eps
	dvi2tty? ( dev-tex/dvi2tty )
	png? ( app-text/dvipng )
	X? ( >=app-text/xdvik-22.87 )
	>=${TEXLIVE_CAT}/texlive-basic-${PV}
	>=${TEXLIVE_CAT}/texlive-fontsrecommended-${PV}
	>=${TEXLIVE_CAT}/texlive-latex-${PV}
	luatex? ( >=${TEXLIVE_CAT}/texlive-luatex-${PV} )
	>=${TEXLIVE_CAT}/texlive-latexrecommended-${PV}
	>=dev-tex/xcolor-2.11
	>=dev-tex/latex-beamer-3.36
	metapost? (
		>=${TEXLIVE_CAT}/texlive-metapost-${PV}
			dev-tex/feynmf
	)
	>=${TEXLIVE_CAT}/texlive-genericrecommended-${PV}
	pdfannotextractor? ( dev-tex/pdfannotextractor )
	extra? (
		dev-tex/chktex
		app-text/dvisvgm
		dev-tex/latexdiff
		>=dev-tex/latexmk-418
		>=app-text/pdfjam-2.02
		>=${TEXLIVE_CAT}/texlive-bibtexextra-${PV}
		>=${TEXLIVE_CAT}/texlive-fontsextra-${PV}
		>=${TEXLIVE_CAT}/texlive-formatsextra-${PV}
		>=${TEXLIVE_CAT}/texlive-genericextra-${PV}
		>=${TEXLIVE_CAT}/texlive-latexextra-${PV}
			>=dev-tex/glossaries-2.07
			>=dev-tex/leaflet-20041222
			>=dev-tex/currvita-0.9i-r1
			>=dev-tex/g-brief-4.0.2
			>=dev-tex/envlab-1.2-r1
			>=dev-tex/europecv-20060424-r1
			>=dev-tex/svninfo-0.7.3-r1
		>=${TEXLIVE_CAT}/texlive-mathextra-${PV}
		>=${TEXLIVE_CAT}/texlive-plainextra-${PV}
	)
	xetex? ( >=${TEXLIVE_CAT}/texlive-xetex-${PV} )
	graphics? ( >=${TEXLIVE_CAT}/texlive-pictures-${PV}
		dev-tex/dot2texi )
	epspdf? ( app-text/epspdf )
	science? ( >=${TEXLIVE_CAT}/texlive-science-${PV} )
	publishers? ( >=${TEXLIVE_CAT}/texlive-publishers-${PV} )
	music? ( >=${TEXLIVE_CAT}/texlive-music-${PV} )
	pstricks? ( >=${TEXLIVE_CAT}/texlive-pstricks-${PV} )
	omega? ( >=${TEXLIVE_CAT}/texlive-omega-${PV} )
	context? ( >=${TEXLIVE_CAT}/texlive-context-${PV} )
	games? ( >=${TEXLIVE_CAT}/texlive-games-${PV} )
	humanities? ( >=${TEXLIVE_CAT}/texlive-humanities-${PV} )
	tex4ht? ( >=dev-tex/tex4ht-20090611_p1038-r3 )
	xml? (
		>=dev-tex/xmltex-1.9-r2
		app-text/passivetex
	)
	jadetex? ( >=app-text/jadetex-3.13-r2 )
	linguas_af? ( >=${TEXLIVE_CAT}/texlive-langafrican-${PV}
				  >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_ar? ( >=${TEXLIVE_CAT}/texlive-langarabic-${PV} )
	linguas_fa? ( >=${TEXLIVE_CAT}/texlive-langarabic-${PV} )
	linguas_hy? ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	cjk? ( >=${TEXLIVE_CAT}/texlive-langcjk-${PV}
		   >=dev-tex/cjk-latex-4.8.3-r1 )
	linguas_hr?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_bg?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	linguas_br?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_ru?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	linguas_uk?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	linguas_cs?    ( >=${TEXLIVE_CAT}/texlive-langczechslovak-${PV} >=app-text/vlna-1.3 )
	linguas_sk?    ( >=${TEXLIVE_CAT}/texlive-langczechslovak-${PV} )
	linguas_da?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_nl?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_en?    ( >=${TEXLIVE_CAT}/texlive-langenglish-${PV} )
	linguas_en_GB? ( >=${TEXLIVE_CAT}/texlive-langenglish-${PV} )
	linguas_fi?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_eu?    ( >=${TEXLIVE_CAT}/texlive-langfrench-${PV} )
	linguas_fr?    ( >=${TEXLIVE_CAT}/texlive-langfrench-${PV} )
	linguas_de?    ( >=${TEXLIVE_CAT}/texlive-langgerman-${PV} )
	linguas_el?    ( >=${TEXLIVE_CAT}/texlive-langgreek-${PV} )
	linguas_he?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_hu?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_as?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_bn?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_gu?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_hi?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_kn?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_ml?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_mr?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_or?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_pa?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_ta?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_te?    ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_sa_IN? ( >=${TEXLIVE_CAT}/texlive-langindic-${PV} )
	linguas_it?    ( >=${TEXLIVE_CAT}/texlive-langitalian-${PV} )
	linguas_ja?    ( >=${TEXLIVE_CAT}/texlive-langjapanese-${PV} )
	linguas_ko?    ( >=${TEXLIVE_CAT}/texlive-langkorean-${PV} )
	linguas_la?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_lt?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_lv?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_mn?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	linguas_nb?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_nn?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_no?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_cy?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_eo?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_et?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_ga?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_rm?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_hsb?   ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_ia?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_id?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_is?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_lo?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_ro?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_sq?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_sr?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV}
	                 >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	linguas_sl?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_tr?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_pl?    ( >=${TEXLIVE_CAT}/texlive-langpolish-${PV} )
	linguas_pt?    ( >=${TEXLIVE_CAT}/texlive-langportuguese-${PV} )
	linguas_ca?    ( >=${TEXLIVE_CAT}/texlive-langspanish-${PV} )
	linguas_gl?    ( >=${TEXLIVE_CAT}/texlive-langspanish-${PV} )
	linguas_es?    ( >=${TEXLIVE_CAT}/texlive-langspanish-${PV} )
	linguas_sco?   ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_sv?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_tk?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	linguas_vi?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	linguas_zh?    ( >=${TEXLIVE_CAT}/texlive-langchinese-${PV} )
	xindy? ( app-text/xindy )
"
