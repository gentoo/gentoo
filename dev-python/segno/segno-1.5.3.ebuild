# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python QR Code and Micro QR Code encoder"
HOMEPAGE="
	https://pypi.org/project/segno/
	https://github.com/heuer/segno/
"
SRC_URI="
	https://github.com/heuer/segno/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	test? (
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pypng[${PYTHON_USEDEP}]
		dev-python/pyzbar[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
