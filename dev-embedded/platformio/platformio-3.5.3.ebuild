# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="An open source ecosystem for IoT development"
HOMEPAGE="http://platformio.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/semantic_version-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/pyserial-3[${PYTHON_USEDEP}]
	<dev-python/pyserial-4[${PYTHON_USEDEP}]
	>=dev-python/lockfile-0.9.1[${PYTHON_USEDEP}]
	<dev-python/lockfile-0.13[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	>=dev-python/click-5[${PYTHON_USEDEP}]
	<dev-python/click-6[${PYTHON_USEDEP}]
	<dev-python/bottle-0.13[${PYTHON_USEDEP}]
	<dev-python/arrow-1[${PYTHON_USEDEP}]"
