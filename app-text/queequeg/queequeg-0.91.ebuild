# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/queequeg/queequeg-0.91.ebuild,v 1.11 2014/08/10 18:30:54 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit python

DESCRIPTION="A checker for English grammar, for people who are not native English"
HOMEPAGE="http://queequeg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-dicts/wordnet"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r ${PYTHON_ABI} .
}

src_compile() {
	local dictdir=/usr/dict

	if has_version ">=app-dicts/wordnet-2.0"; then
		dictdir=/usr/share/wordnet/dict
	fi

	emake dict WORDNETDICT=${dictdir} || die
}

src_install() {
	local prefix=$(python_get_sitedir)/${PN}

	insinto ${prefix}
	doins *.py
	[[ -f "dict.txt" ]] && doins dict.txt || doins dict.cdb

	exeinto ${prefix}
	doexe qq
	dosym ${prefix}/qq /usr/bin/qq

	dodoc README TODO
	dohtml htdocs/*
}

pkg_postinst() {
	python_mod_optimize queequeg
}

pkg_postrm() {
	python_mod_cleanup queequeg
}
