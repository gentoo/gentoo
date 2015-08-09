# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="2"

inherit distutils eutils

MY_P=PLWM-${PV/_}

DESCRIPTION="Python classes for, and an implementation of, a window manager"
HOMEPAGE="http://plwm.sourceforge.net/"
SRC_URI="mirror://sourceforge/plwm/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-python/python-xlib-0.14"
DEPEND="sys-apps/texinfo"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-pep0263.patch
	python_convert_shebangs -r 2 examples/examplewm.py utils/*.py
	distutils_src_prepare
}

src_compile() {
	distutils_src_compile
	emake -C doc || die
}

src_install() {
	distutils_src_install

	newbin examples/examplewm.py plwm || die
	dobin utils/*.py || die

	doinfo doc/*.info || die

	dodoc {,O}NEWS || die
	docinto examples
	dodoc examples/* || die
	docinto utils
	dodoc utils/ChangeLog || die
}
