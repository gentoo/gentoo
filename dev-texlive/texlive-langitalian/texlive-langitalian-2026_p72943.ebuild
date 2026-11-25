# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

TEXLIVE_MODULE_CONTENTS="
	collection-langitalian.r79075
	antanilipsum.r77161
	attinormativi.r79199
	babel-italian.r77371
	biblatex-accursius.r72942
	codicefiscaleitaliano.r29803
	fixltxhyph.r73227
	frontespizio.r79618
	hyphen-italian.r78069
	itnumpar.r79618
	layaureo.r19087
	verifica.r75682
"
TEXLIVE_MODULE_SRC_CONTENTS="
	amsldoc-it.doc.r45662
	amsmath-it.doc.r22930
	amsthdoc-it.doc.r45662
	antanilipsum.doc.r77161
	attinormativi.doc.r79199
	babel-italian.doc.r77371
	biblatex-accursius.doc.r72942
	codicefiscaleitaliano.doc.r29803
	fancyhdr-it.doc.r21912
	fixltxhyph.doc.r73227
	frontespizio.doc.r79618
	itnumpar.doc.r79618
	l2tabu-italian.doc.r25218
	latex4wp-it.doc.r36000
	layaureo.doc.r19087
	lshort-italian.doc.r79461
	psfrag-italian.doc.r15878
	texlive-it.doc.r58653
	verifica.doc.r75682
"
TEXLIVE_MODULE_DOC_CONTENTS="
	antanilipsum.source.r77161
	attinormativi.source.r79199
	babel-italian.source.r77371
	biblatex-accursius.source.r72942
	codicefiscaleitaliano.source.r29803
	fixltxhyph.source.r73227
	frontespizio.source.r79618
	itnumpar.source.r79618
	layaureo.source.r19087
	verifica.source.r75682
"

inherit texlive-module

DESCRIPTION="TeXLive Italian"

LICENSE="FDL-1.1+ GPL-1+ GPL-2+ LGPL-2+ LPPL-1.2 LPPL-1.3 LPPL-1.3c TeX-other-free"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
COMMON_DEPEND="
	>=dev-texlive/texlive-basic-2026
"
RDEPEND="
	${COMMON_DEPEND}
"
DEPEND="
	${COMMON_DEPEND}
"
