# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Generate an XML description of a C++ program from GCC's internal representation"
HOMEPAGE="http://www.language-binding.net/"
SRC_URI="mirror://sourceforge/pygccxml/${P}.zip"

LICENSE="freedist Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="
	app-arch/unzip
	doc? ( >=dev-python/epydoc-3[${PYTHON_USEDEP}] )"
RDEPEND=">=dev-cpp/gccxml-0.6"

python_compile_all() {
	use doc && esetup.py doc
}

python_test() {
	"${PYTHON}" unittests/test_all.py
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/apidocs/. )
	use examples && local EXAMPLES=( docs/example/. )

	distutils-r1_python_install_all
}
