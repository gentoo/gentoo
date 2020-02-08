# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,8} )
inherit distutils-r1 flag-o-matic

DESCRIPTION="Python bindings for sys-block/parted"
HOMEPAGE="https://github.com/rhinstaller/pyparted/"
SRC_URI="https://github.com/rhinstaller/pyparted/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=sys-block/parted-3.1
	dev-python/decorator[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

distutils_enable_tests unittest

src_configure() {
	append-cflags -fcommon
	default
}
