# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Adds read support for DBF files to agate."
HOMEPAGE="https://github.com/wireservice/agate-dbf https://pypi.org/project/agate-dbf/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND=""

RDEPEND="
	>=dev-python/agate-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/dbfread-2.0.5[${PYTHON_USEDEP}]
"
