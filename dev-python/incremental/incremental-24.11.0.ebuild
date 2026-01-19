# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/twisted/incremental
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Incremental is a small library that versions your Python projects"
HOMEPAGE="
	https://github.com/twisted/incremental/
	https://pypi.org/project/Incremental/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/packaging-17.0[${PYTHON_USEDEP}]
"
# note: most of test deps are for examples that we can't run without
# Internet
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/twisted[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" -m twisted.trial incremental ||
		die "Tests failed on ${EPYTHON}"
}
