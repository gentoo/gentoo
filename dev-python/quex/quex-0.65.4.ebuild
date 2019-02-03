# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Mode Oriented Directly Coded Lexical Analyser Generator"
HOMEPAGE="http://quex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s:@PYTHON_SITEDIR@:$(python_get_sitedir):g" \
		quex/DEFINITIONS.py || die
	mv quex/engine/codec_db/database . || die
}

src_install() {
	default
	insinto /usr/share/quex
	doins -r database
	dosym $(python_get_sitedir)/quex/code_base /usr/include/quex/code_base

	python_domodule quex
	python_newexe quex-exe.py quex
	doman manpage/quex.1
	dodoc -r demo
}
