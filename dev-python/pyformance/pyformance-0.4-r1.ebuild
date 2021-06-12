# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Performance metrics, based on Coda Hale's Yammer metrics"
HOMEPAGE="https://pyformance.readthedocs.org/ https://github.com/omergertel/pyformance/ https://pypi.org/project/pyformance/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~chutzpah/dist/python/${P}-patches.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

PATCHES=(
	"${WORKDIR}/${P}-patches"
)

python_prepare() {
	sed -e "s/find_packages()/find_packages(exclude=['tests'])/" \
		-i setup.py || die
}
