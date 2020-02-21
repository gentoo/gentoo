# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="CLI for podman written in python"
HOMEPAGE="https://github.com/containers/libpod/tree/master/contrib/python/pypodman/"
SRC_URI="https://github.com/containers/libpod/archive/v${PV}.tar.gz -> libpod-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/python-podman[${PYTHON_USEDEP}]
	dev-python/pytoml[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/setuptools-39[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
RESTRICT="test"

S="${WORKDIR}/libpod-${PV}/contrib/python/pypodman"

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
