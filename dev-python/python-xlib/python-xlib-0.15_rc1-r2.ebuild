# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_P="${P/_/}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="http://python-xlib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="doc"

python_prepare_all() {
	sed -e 's:make:$(MAKE):g' -i doc/Makefile || die
	cp -r "${FILESDIR}"/defs doc/src/ || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		cd doc || die
		VARTEXFONTS="${T}"/fonts emake html
	fi
}

python_test() {
	cd test || die

	local t
	for t in *.py; do
		"${PYTHON}" "${t}" || die
	done
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
