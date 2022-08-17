# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
DISTUTULS_USE_SETUPTOOLS="pyproject.toml"

inherit distutils-r1

DESCRIPTION="Creates a changelog from git log history"
HOMEPAGE="https://github.com/sarnold/gitchangelog"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/gitchangelog.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

BDEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/minimock[${PYTHON_USEDEP}] )
"

DEPEND="${PYTHON_DEPS}
	dev-python/pystache[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
"

RESTRICT="!test? ( test )"

python_test() {
	"${EPYTHON}" -m nose -sx . || die "Testing failed with ${EPYTHON}"
}
