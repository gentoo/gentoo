# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

MY_PV=${PV/_p/-r}
MY_P=${PN}-${MY_PV}

DESCRIPTION="APSW - Another Python SQLite Wrapper"
HOMEPAGE="https://github.com/rogerbinns/apsw/"
SRC_URI="https://github.com/rogerbinns/apsw/releases/download/${MY_PV}/${MY_P}.zip -> ${P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="doc"

RDEPEND=">=dev-db/sqlite-${PV%_p*}"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}/${PN}-3.6.20.1-fix_tests.patch" )

python_prepare_all() {
	sed -e 's/"gcc/os.environ.get("CC", "gcc") + "/' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile --enable=load_extension
}

python_test() {
	esetup.py build_test_extension
	"${EPYTHON}" tests.py -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
