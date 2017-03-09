# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="A checker for English grammar, for people who are not native English"
HOMEPAGE="http://queequeg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	app-dicts/wordnet"
RDEPEND="${DEPEND}"

src_compile() {
	local dictdir=/usr/dict

	if has_version ">=app-dicts/wordnet-2.0"; then
		dictdir=/usr/share/wordnet/dict
	fi

	emake dict WORDNETDICT=${dictdir}

	python_fix_shebang qq
}

src_install() {
	local prefix=/usr/lib/queequeg

	python_moduleinto "${prefix}"
	python_domodule *.py
	insinto "${prefix}"
	[[ -f "dict.txt" ]] && doins dict.txt || doins dict.cdb

	exeinto "${prefix}"
	doexe qq
	dodir /usr/bin
	dosym ../lib/queequeg/qq /usr/bin/qq

	dodoc README TODO
	dodoc htdocs/*
}
