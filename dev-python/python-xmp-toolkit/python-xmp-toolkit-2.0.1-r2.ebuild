# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/python-xmp-toolkit/${PN}.git"
else
	SRC_URI="https://github.com/python-xmp-toolkit/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Library for working with XMP metadata"
HOMEPAGE="https://github.com/python-xmp-toolkit/python-xmp-toolkit/ https://pypi.org/project/python-xmp-toolkit/"

LICENSE="BSD"
SLOT="0"

DEPEND="
	test? ( media-libs/exempi )
"
RDEPEND="
	dev-python/pytz[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${P}-test.patch )

distutils_enable_sphinx docs
distutils_enable_tests unittest
