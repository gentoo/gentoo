# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="Generate an XML description of a C++ program from GCC's internal representation"
HOMEPAGE="https://github.com/gccxml/pygccxml"
SRC_URI="https://github.com/gccxml/pygccxml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="freedist Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	app-arch/unzip
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-cpp/gccxml-0.6"

python_compile_all() {
	use doc && emake html man
}

python_test() {
	"${PYTHON}" unittests/test_all.py
}

python_install_all() {
	if use doc ; then
		local HTML_DOCS=( docs/_build/html )
		doman docs/_build/man/${PN}.1
	fi

	distutils-r1_python_install_all
}
