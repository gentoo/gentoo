# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

# see scripts/download_import_cldr.py
CLDR_PV=41.0
DESCRIPTION="Collection of tools for internationalizing Python applications"
HOMEPAGE="
	https://babel.pocoo.org/
	https://pypi.org/project/Babel/
	https://github.com/python-babel/babel/
"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://unicode.org/Public/cldr/${CLDR_PV%.*}/cldr-common-${CLDR_PV}.zip
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/pytz[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/backports-zoneinfo[${PYTHON_USEDEP}]
	' 3.8)
"
# RDEPEND in BDEPEND for import_cldr.py usage, bug #852158
BDEPEND="
	app-arch/unzip
	${RDEPEND}
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	rm babel/locale-data/*.dat || die
	rm babel/global.dat || die
	distutils-r1_src_prepare
}

python_configure() {
	if [[ ! -f babel/global.dat ]]; then
		"${EPYTHON}" scripts/import_cldr.py "${WORKDIR}"/common || die
	fi
}

python_test() {
	local -x TZ=UTC
	epytest
}
