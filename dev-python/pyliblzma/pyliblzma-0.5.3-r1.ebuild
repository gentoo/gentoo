# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for liblzma"
HOMEPAGE="https://launchpad.net/pyliblzma https://pypi.org/project/pyliblzma"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~ppc ~x86"
IUSE=""

RDEPEND="
	app-arch/xz-utils"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS="THANKS"

python_test() {
	esetup.py test
}
