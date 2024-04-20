# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Adds read support for DBF files to agate"
HOMEPAGE="
	https://github.com/wireservice/agate-dbf/
	https://pypi.org/project/agate-dbf/
"
SRC_URI="
	https://github.com/wireservice/agate-dbf/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/agate-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/dbfread-2.0.5[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/furo
distutils_enable_tests pytest
