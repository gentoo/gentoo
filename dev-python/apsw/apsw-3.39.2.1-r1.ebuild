# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="APSW - Another Python SQLite Wrapper"
HOMEPAGE="
	https://github.com/rogerbinns/apsw/
	https://pypi.org/project/apsw/
"
SRC_URI="
	https://github.com/rogerbinns/apsw/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="doc"

DEPEND="
	>=dev-db/sqlite-${PV%.*}:3
"
RDEPEND="
	${DEPEND}
"

python_compile() {
	# Needed for e.g. bug #851741
	# Enable column-metadata to match dev-db/sqlite
	distutils-r1_python_compile --enable=load_extension,column_metadata
}

python_test() {
	esetup.py build_test_extension
	"${EPYTHON}" apsw/tests.py -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
