# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Generates and parses RFC 3339 timestamps"
HOMEPAGE="https://github.com/kurtraschke/pyRFC3339"
SRC_URI="
	https://github.com/kurtraschke/pyRFC3339/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/pyRFC3339-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="dev-python/pytz[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-pytest.patch"
)

distutils_enable_tests pytest

python_test() {
	epytest pyrfc3339/tests/tests.py
}
