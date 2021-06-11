# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A library to interact with a Podman server"
HOMEPAGE="https://github.com/containers/python-podman/ https://pypi.org/project/podman/"
MY_PN=${PN#python-}
MY_P=${MY_PN}-${PV}
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-varlink[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/pbr[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_test() {
	"${PYTHON}" -m unittest discover tests/ || die "tests failed with ${EPYTHON}"
}
