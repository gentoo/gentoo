# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A library for communicating with a Podman server"
HOMEPAGE="https://github.com/containers/libpod/tree/master/contrib/python/podman/"
SRC_URI="https://github.com/containers/libpod/archive/v${PV}.tar.gz -> libpod-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-varlink[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-python/setuptools-39[${PYTHON_USEDEP}]"
RESTRICT="test"
S="${WORKDIR}/libpod-${PV}/contrib/python/podman"

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
