# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm-utils/gtkmm-utils-0.4.1.ebuild,v 1.1 2012/12/23 09:46:25 hwoarang Exp $

EAPI=4

inherit eutils

DESCRIPTION="Utility functions, classes and widgets written on top of gtkmm and
glibmm."
HOMEPAGE="http://code.google.com/p/gtkmm-utils/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-cpp/gtkmm:2.4"
DEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-glib.patch"
	epatch "${FILESDIR}/${P}-include-fix.patch"
}

src_configure() {
	econf $(use_enable doc documentation)
}
