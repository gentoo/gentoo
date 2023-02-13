# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Utitilies for maintaining Python packages"
HOMEPAGE="
	https://github.com/projg2/gpyutils/
	https://pypi.org/project/gpyutils/
"
SRC_URI="
	https://github.com/projg2/gpyutils/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=app-portage/gentoopm-0.3.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
