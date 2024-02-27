# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE="doc"

DEPEND="
	>=dev-db/sqlite-${PV%.*}:3
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	cat >> setup.cfg <<-EOF || die
		[build_ext]
		enable=load_extension
		use_system_sqlite_config=True
	EOF
}

python_test() {
	esetup.py build_test_extension
	cd "${T}" || die
	"${EPYTHON}" -m apsw.tests -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
