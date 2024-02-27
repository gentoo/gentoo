# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

DESCRIPTION="Linux/OSX/FreeBSD resource monitor"
HOMEPAGE="
	https://github.com/aristocratos/bpytop/
	https://pypi.org/project/bpytop/
"
SRC_URI="
	https://github.com/aristocratos/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/psutil-5.7.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/bpytop-1.0.63-tests.patch"
)

src_install() {
	insinto "/usr/share/${PN}/themes"
	doins bpytop-themes/*.theme
	distutils-r1_src_install
}

python_test() {
	EPYTEST_DESELECT=(
		tests/test_functions.py::test_get_cpu_core_mapping
	)
	epytest
}
