# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python port of the YUI CSS compression algorithm"
HOMEPAGE="
	https://pypi.org/project/cssmin/
	https://github.com/zacharyvoase/cssmin/
"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
