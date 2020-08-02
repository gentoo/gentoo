# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

inherit distutils-r1

DESCRIPTION="Performance metrics, based on Coda Hale's Yammer metrics"
HOMEPAGE="https://pyformance.readthedocs.org/ https://github.com/omergertel/pyformance/ https://pypi.org/project/pyformance/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~chutzpah/dist/python/pyformance-0.4-patches.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=(
	"${WORKDIR}/pyformance-0.4-patches"
)

python_prepare() {
	sed -e "s/find_packages()/find_packages(exclude=['tests'])/" \
		-i setup.py || die
}
