# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python bindings for sys-block/parted"
HOMEPAGE="https://github.com/dcantrell/pyparted/"
SRC_URI="https://github.com/dcantrell/pyparted/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"

DEPEND="
	>=sys-block/parted-3.4
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? ( dev-python/six[${PYTHON_USEDEP}] )
	virtual/pkgconfig
"

distutils_enable_tests unittest
