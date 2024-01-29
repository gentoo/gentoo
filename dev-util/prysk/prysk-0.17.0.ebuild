# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..12} pypy3 )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

DESCRIPTION="Functional testing framework for command line applications"
HOMEPAGE="https://www.prysk.net/"
# pypi doesn't includes tests
SRC_URI="https://github.com/prysk/prysk/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

distutils_enable_tests pytest

RDEPEND="
	$(python_gen_cond_dep '>=dev-python/rich-13.3.1[${PYTHON_USEDEP}]')
"

python_test() {
	distutils-r1_python_test

	# --shell=bash because it fails with mksh
	# https://github.com/prysk/prysk/issues/230
	"${EPYTHON}" -m prysk --shell=bash test/integration || die "Tests fail with ${EPYTHON}"
}
