# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Bram Moolenaar's super-make program"
HOMEPAGE="http://www.a-a-p.org/"
SRC_URI="mirror://sourceforge/a-a-p/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
S=${WORKDIR}

PATCHES=( "${FILESDIR}"/${P}-module-install.patch )

src_test() {
	"${PYTHON}" aap || die "tests failed"
	rm -r AAPDIR || die
}

src_install() {
	rm -r rectest unittest test.aap || die
	rm doc/*.sgml doc/*.pdf COPYING README.txt || die
	if use doc; then
		docinto html
		dodoc -r doc/*.html doc/images
	fi
	rm -r doc/*.html doc/images || die

	docinto /
	dodoc doc/*
	doman aap.1
	rm -r doc aap.1 || die

	python_doscript aap
	rm aap aap.py aap.bat || die

	python_moduleinto aap
	python_domodule .
}
