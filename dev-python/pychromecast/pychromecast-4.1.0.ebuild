# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="Python module to talk to Google Chromecast."
HOMEPAGE="https://github.com/balloob/pychromecast"
SRC_URI="mirror://pypi/P/PyChromecast/PyChromecast-${PV}.tar.gz"
S="${WORKDIR}/PyChromecast-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/requests-2.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/zeroconf-0.17.7[${PYTHON_USEDEP}]
	>=dev-python/casttube-0.2.0[${PYTHON_USEDEP}]"
BDEPEND=""
