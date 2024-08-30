# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=PyChromecast
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python module to talk to Google Chromecast"
HOMEPAGE="
	https://github.com/home-assistant-libs/pychromecast/
	https://pypi.org/project/PyChromecast/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/casttube-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.19.1[${PYTHON_USEDEP}]
	>=dev-python/zeroconf-0.25.1[${PYTHON_USEDEP}]
"
