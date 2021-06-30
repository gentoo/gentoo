# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="a python parser that supports error recovery and round-trip parsing"
HOMEPAGE="https://github.com/davidhalter/parso https://pypi.org/project/parso/"
SRC_URI="https://github.com/davidhalter/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv ~sparc x86"

distutils_enable_sphinx docs
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-py310.patch
)

python_test() {
	local deselect=()
	[[ ${EPYTHON} == python3.10 ]] && deselect+=(
		# py3.10 changed exception messages
		test/test_python_errors.py::test_python_exception_matches
		test/test_python_errors.py::test_default_except_error_postition
	)
	epytest ${deselect[@]/#/--deselect }
}
