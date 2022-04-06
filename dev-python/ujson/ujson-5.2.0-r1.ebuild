# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Ultra fast JSON encoder and decoder for Python"
HOMEPAGE="https://pypi.org/project/ujson/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-libs/double-conversion:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_configure() {
	export UJSON_BUILD_DC_INCLUDES="/usr/include/double-conversion"
	export UJSON_BUILD_DC_LIBS="-ldouble-conversion"
	export UJSON_BUILD_NO_STRIP=1
}
