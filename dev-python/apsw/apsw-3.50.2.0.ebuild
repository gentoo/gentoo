# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="APSW - Another Python SQLite Wrapper"
HOMEPAGE="
	https://github.com/rogerbinns/apsw/
	https://pypi.org/project/apsw/
"
SRC_URI="
	https://github.com/rogerbinns/apsw/releases/download/${PV}/${P}.zip
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ppc64 x86"
IUSE="doc"

DEPEND="
	>=dev-db/sqlite-${PV%.*}:3
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-arch/unzip
"

src_configure() {
	cat >> setup.apsw <<-EOF || die
		[build_ext]
		use_system_sqlite_config=True
	EOF
}

python_test() {
	esetup.py build_test_extension
	cd "${T}" || die
	"${EPYTHON}" -m apsw.tests -v || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	doman man/apsw.1
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}
