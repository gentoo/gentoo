# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python library to use the pseudo-tty of a docker container"
HOMEPAGE="https://github.com/d11wtq/dockerpty"
SRC_URI="https://github.com/d11wtq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		>=dev-python/docker-py-0.7.0_rc2[${PYTHON_USEDEP}]
		>=dev-python/expects-0.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.5.2[${PYTHON_USEDEP}]
	)
"
RDEPEND=">=dev-python/six-1.3.0[${PYTHON_USEDEP}]"

python_test() {
	py.test tests || die "Tests failed under ${EPYTHON}"
}
