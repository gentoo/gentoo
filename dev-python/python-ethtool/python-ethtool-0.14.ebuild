# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )

# TODO: install scripts and their man pages

inherit distutils-r1

DESCRIPTION="Ethernet settings python bindings"
HOMEPAGE="https://pypi.org/project/ethtool/
	https://github.com/fedora-python/python-ethtool"
SRC_URI="https://github.com/fedora-python/python-ethtool/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/libnl:3"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/test-skip-wg-dev.patch )

python_test() {
	esetup.py test || die "Tests failed with ${EPYTHON}"
}
