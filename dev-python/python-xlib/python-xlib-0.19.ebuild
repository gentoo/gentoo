# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="A fully functional X client library for Python, written in Python"
HOMEPAGE="https://github.com/python-xlib/python-xlib"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

# DISTUTILS_IN_SOURCE_BUILD=1

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
		"${EPYTHON}" "${t}" || die
	done
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/html/. )
	distutils-r1_python_install_all
}
