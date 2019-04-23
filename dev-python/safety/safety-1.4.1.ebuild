# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit distutils-r1

DESCRIPTION="Checks your installed dependencies for known security vulnerabilities"
HOMEPAGE="https://github.com/pyupio/safety"
SRC_URI="https://github.com/pyupio/safety/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/setuptools-16[${PYTHON_USEDEP}]
	>=dev-python/click-6.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}"

python_test() {
	esetup.py test || die
}
