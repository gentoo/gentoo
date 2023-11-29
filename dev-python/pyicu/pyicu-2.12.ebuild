# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=${P/-/-v}
DESCRIPTION="Python bindings for dev-libs/icu"
HOMEPAGE="
	https://gitlab.pyicu.org/main/pyicu/
	https://pypi.org/project/PyICU/
"
SRC_URI="
	https://gitlab.pyicu.org/main/pyicu/-/archive/v${PV}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv x86 ~arm64-macos ~x64-macos"

DEPEND="
	dev-libs/icu:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES CREDITS README.md )

distutils_enable_tests pytest

python_test() {
	epytest test
}
