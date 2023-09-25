# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Performance metrics, based on Coda Hale's Yammer metrics"
HOMEPAGE="
	https://pyformance.readthedocs.org/
	https://github.com/omergertel/pyformance/
	https://pypi.org/project/pyformance/
"
SRC_URI+="
	https://dev.gentoo.org/~chutzpah/dist/python/${P}-patches.tar.xz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${WORKDIR}/${P}-patches"
)

src_prepare() {
	sed -e "s/find_packages()/find_packages(exclude=['tests'])/" \
		-i setup.py || die
	distutils-r1_src_prepare
}
