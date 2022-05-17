# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Utitilies for maintaining Python packages"
HOMEPAGE="
	https://github.com/mgorny/gpyutils/
	https://pypi.org/project/gpyutils/
"
SRC_URI="
	https://github.com/mgorny/gpyutils/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=app-portage/gentoopm-0.3.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest --doctest-modules gpyutils
}
