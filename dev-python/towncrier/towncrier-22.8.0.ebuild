# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Building newsfiles for your project"
HOMEPAGE="
	https://github.com/twisted/towncrier/
	https://pypi.org/project/towncrier/
"
SRC_URI="
	https://github.com/twisted/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/click-default-group[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/incremental[${PYTHON_USEDEP}]
	test? (
		dev-vcs/git
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" -m twisted.trial towncrier ||
		die "tests failed with ${EPYTHON}"
}
