# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Ultra fast JSON encoder and decoder for Python"
HOMEPAGE="
	https://github.com/ultrajson/ultrajson/
	https://pypi.org/project/ujson/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

DEPEND="
	dev-libs/double-conversion:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_configure() {
	export UJSON_BUILD_DC_INCLUDES="${EPREFIX}/usr/include/double-conversion"
	export UJSON_BUILD_DC_LIBS="-ldouble-conversion"
	export UJSON_BUILD_NO_STRIP=1
}
