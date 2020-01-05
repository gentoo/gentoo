# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6)

inherit eutils distutils-r1

DESCRIPTION="GitHub API client implemented using Twisted"
HOMEPAGE="https://github.com/tomprince/txgithub https://pypi.org/project/txgithub/"
SRC_URI="https://github.com/tomprince/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	|| ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		( >=dev-python/twisted-core-12.3.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-web-12.3.0[${PYTHON_USEDEP}] )
	)
	dev-python/pyopenssl[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_test() {
	PYTHONPATH="${S}/test:${BUILD_DIR}/lib" py.test -v || die "Tests failed under ${EPYTHON}"
}
