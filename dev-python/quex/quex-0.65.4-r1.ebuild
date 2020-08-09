# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Mode Oriented Directly Coded Lexical Analyser Generator"
HOMEPAGE="http://quex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
BDEPEND="${RDEPEND}"
DEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	sed -i \
		-e "s:@PYTHON_SITEDIR@:$(python_get_sitedir):g" \
		quex/DEFINITIONS.py || die
	mv quex/engine/codec_db/database . || die
	mv quex/code_base . || die
}

src_install() {
	default
	insinto /usr/share/quex
	doins -r database
	doins -r code_base

	python_domodule quex
	python_newscript quex-exe.py quex
	doman manpage/quex.1
	dodoc -r demo
	insinto /etc/profile.d/
	doins "${FILESDIR}"/quex.sh
}
