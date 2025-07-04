# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Library for working with XMP metadata"
HOMEPAGE="
	https://github.com/python-xmp-toolkit/python-xmp-toolkit/
	https://pypi.org/project/python-xmp-toolkit/
"
SRC_URI="
	https://github.com/python-xmp-toolkit/python-xmp-toolkit/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv x86"

RDEPEND="
	dev-python/pytz[${PYTHON_USEDEP}]
	media-libs/exempi
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.1-test.patch
)

distutils_enable_sphinx docs
distutils_enable_tests unittest
