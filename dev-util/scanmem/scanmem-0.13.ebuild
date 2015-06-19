# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/scanmem/scanmem-0.13.ebuild,v 1.2 2015/06/04 19:02:21 kensington Exp $

EAPI=4
PYTHON_DEPEND="gui? 2"

inherit autotools eutils python

DESCRIPTION="Locate and modify variables in executing processes"
HOMEPAGE="http://code.google.com/p/scanmem/"
SRC_URI="http://scanmem.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui kde"

DEPEND="sys-libs/readline"
RDEPEND="${DEPEND}
	gui? (
		dev-python/pygtk:2
		kde? ( kde-apps/kdesu )
		!kde? ( x11-libs/gksu )
	)"

src_prepare() {
	epatch "${FILESDIR}"/${P}-configure.patch
	epatch "${FILESDIR}"/${P}-desktop.patch
	epatch "${FILESDIR}"/${P}-docs.patch
	sed -i "/CFLAGS/d" Makefile.am || die

	if use gui ; then
		sed -i "s/python/python2/" gui/gameconqueror.in || die

		if use kde ; then
			sed -i 's/gksu --description "GameConqueror"/kdesu -c/' gui/gameconqueror.in || die
		fi
	fi

	eautoreconf
	chmod +x configure
}

src_configure() {
	econf \
		$(use_enable gui)
}

src_install() {
	default

	if use gui ; then
		docinto gui
		dodoc gui/{README,TODO}
	fi
}
