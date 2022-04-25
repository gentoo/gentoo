# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS="pyproject.toml"

inherit distutils-r1

DESCRIPTION="Updated Python implementation of Mustache templating framework"
HOMEPAGE="https://github.com/PennyDreadfulMTG/pystache"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/PennyDreadfulMTG/pystache.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
"

RDEPEND="${PYTHON_DEPS}"

RESTRICT="!test? ( test )"

python_test() {
	distutils_install_for_testing
	pystache-test . || die "Test failed with ${EPYTHON}"
}
