# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python library for Intel HEX files manipulations"
HOMEPAGE="https://pypi.org/project/IntelHex/ https://github.com/python-intelhex/intelhex"
SRC_URI="mirror://pypi/I/IntelHex/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

distutils_enable_tests setup.py

src_prepare() {
	# upstream don't run their own tests when releasing...
	[[ ${PV} == 2.2.1 ]] || die "Revisit on bump"
	sed -i -e 's:2.2:&.1:' scripts/*.py || die

	distutils-r1_src_prepare
}
