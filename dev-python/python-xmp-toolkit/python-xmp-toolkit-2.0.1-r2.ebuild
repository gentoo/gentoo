# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

DEPEND="
	test? ( media-libs/exempi )
"
RDEPEND="
	dev-python/pytz[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${P}-test.patch
)

distutils_enable_sphinx docs
distutils_enable_tests unittest
