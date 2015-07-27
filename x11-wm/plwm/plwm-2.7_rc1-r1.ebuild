# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/plwm/plwm-2.7_rc1-r1.ebuild,v 1.1 2015/07/27 18:38:45 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_P=PLWM-${PV/_}

DESCRIPTION="Python classes for, and an implementation of, a window manager"
HOMEPAGE="http://plwm.sourceforge.net/"
SRC_URI="mirror://sourceforge/plwm/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-python/python-xlib-0.14[${PYTHON_USEDEP}]"
DEPEND="sys-apps/texinfo"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-pep0263.patch
)

python_compile_all() {
	emake -C "${S}"/doc
}

python_install() {
	distutils-r1_python_install

	python_newscript examples/examplewm.py plwm
	python_doscript utils/*.py
}

python_install_all() {
	distutils-r1_python_install_all

	doinfo doc/*.info

	dodoc ONEWS
	dodoc -r examples
	docinto utils
	dodoc utils/ChangeLog
}
