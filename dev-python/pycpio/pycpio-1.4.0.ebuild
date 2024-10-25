# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Python CPIO library"
HOMEPAGE="https://github.com/desultory/pycpio/"
SRC_URI="
	https://github.com/desultory/pycpio/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/zenlib-2.3.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}
