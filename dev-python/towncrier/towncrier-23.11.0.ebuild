# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

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
	dev-python/incremental[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	dev-python/incremental[${PYTHON_USEDEP}]
	test? (
		dev-vcs/git
		>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# unbundle click-default-group, sigh
	rm src/towncrier/click_default_group.py || die
	sed -i -e '/click_default_group/s:[.]::' src/towncrier/_shell.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" -m twisted.trial towncrier ||
		die "tests failed with ${EPYTHON}"
}
