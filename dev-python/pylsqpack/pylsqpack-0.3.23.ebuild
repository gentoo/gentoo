# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for the ls-qpack QPACK library"
HOMEPAGE="
	https://github.com/aiortc/pylsqpack/
	https://pypi.org/project/pylsqpack/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~x86"

DEPEND="
	dev-libs/ls-qpack:=
"
RDEPEND="
	${DEPEND}
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PN}-0.3.20-unbundle.patch"
	)

	distutils-r1_src_prepare
	rm -r vendor || die
}
