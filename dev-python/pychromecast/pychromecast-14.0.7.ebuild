# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

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
	>=dev-python/protobuf-4.25.1[${PYTHON_USEDEP}]
	>=dev-python/zeroconf-0.25.1[${PYTHON_USEDEP}]
"
