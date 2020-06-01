# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="A dot-accessible dictionary (a la JavaScript objects)"
HOMEPAGE="https://github.com/Infinidat/munch"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"

BDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	test? ( >=dev-python/pyyaml-5.1[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/munch-2.5.0-revert-pbr.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i "s:__version__:'${PV}':" setup.py || die
}
