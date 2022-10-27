# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python module to talk to Google Chromecast"
HOMEPAGE="https://github.com/home-assistant-libs/pychromecast"
S="${WORKDIR}/PyChromecast-${PV}"
SRC_URI="mirror://pypi/P/PyChromecast/PyChromecast-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/casttube-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-zeroconf-0.25.1[${PYTHON_USEDEP}]"
