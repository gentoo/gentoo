# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for running a display inside X virtual framebuffer"
HOMEPAGE="
	https://github.com/cgoldberg/xvfbwrapper/
	https://pypi.org/project/xvfbwrapper/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-base/xorg-server[xvfb]
"

distutils_enable_tests unittest
