# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/qcharselect/qcharselect-0.3.ebuild,v 1.2 2013/11/03 12:41:16 yngwin Exp $

EAPI=5
inherit multilib

DESCRIPTION="A Qt4 port of KCharSelect from KDE 3.5"
HOMEPAGE="http://qcharselect.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-qt/qtgui:4[qt3support]"
DEPEND="$RDEPEND
	x11-misc/makedepend"

src_prepare() {
	sed -e 's:update-mime-database:true:g' \
		-e 's:data/desktop/qcharselect:src/QCharSelect:' \
		-i Makefile.in || die

	sed -e 's: %m::' \
		-e '/Path=/d' \
		-i src/QCharSelect.desktop || die
}

src_configure() {
	local myconf
	use debug && myconf="--enable-debug"

	econf \
		--with-qtdir=/usr \
		--with-qtlibdir=/usr/$(get_libdir)/qt4 \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
}
