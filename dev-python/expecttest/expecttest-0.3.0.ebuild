# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="golden tests"
HOMEPAGE="
	https://github.com/pytorch/expecttest/
	https://pypi.org/project/expecttest/
"
SRC_URI="
	https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" test_expecttest.py -v || die
}
