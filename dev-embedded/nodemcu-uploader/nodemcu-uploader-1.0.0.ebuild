# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Simple tool for uploading files to the filesystem of an ESP8266 running NodeMCU"
HOMEPAGE="https://github.com/kmpm/nodemcu-uploader"
SRC_URI="https://github.com/kmpm/nodemcu-uploader/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pyserial-3.4[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
