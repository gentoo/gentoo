# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="A small Python module to parse various kinds of time expressions"
HOMEPAGE="https://github.com/wroberts/pytimeparse https://pypi.org/project/pytimeparse/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

python_test() {
	local unittest_args=(
		--verbose
		--locals
		pytimeparse.tests.testtimeparse
	)

	"${PYTHON}" -m unittest "${unittest_args[@]}" || die "Tests failed with ${EPYTHON}"
}
