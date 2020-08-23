# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Provides r/w access to a wireless network card's capabilities"
HOMEPAGE="https://pypi.org/project/python-wifi/"
SRC_URI="mirror://sourceforge/${PN}.berlios/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
LICENSE="LGPL-2.1 examples? ( GPL-2 )"
IUSE="examples"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( docs/AUTHORS docs/BUGS docs/DEVEL.txt docs/TODO )

src_install() {
	distutils-r1_src_install
	use examples && dodoc -r examples
	rm -rv "${ED}"/usr/{docs,examples,INSTALL,README} || die
	if use examples; then
		mv -v "${ED}"/usr{,/share}/man || die
	else
		rm -rv "${ED}"/usr/man || die
	fi
}
