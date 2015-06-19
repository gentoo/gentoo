# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-bridge/scim-bridge-0.4.16-r2.ebuild,v 1.7 2013/04/21 10:20:56 lxnay Exp $

EAPI="2"

inherit autotools eutils gnome2-utils multilib

DESCRIPTION="Yet another IM-client of SCIM"
HOMEPAGE="http://www.scim-im.org/projects/scim_bridge"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="doc gtk qt4"

RESTRICT="test"

RDEPEND=">=app-i18n/scim-1.4.6
	gtk? (
		>=x11-libs/gtk+-2.2:2
		>=x11-libs/pango-1.1
	)
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtcore:4
		>=x11-libs/pango-1.1
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.4.15.2-qt4.patch"
	epatch "${FILESDIR}/${PN}-0.4.15.2-gcc43.patch"
	epatch "${FILESDIR}/${P}+gcc-4.4.patch"
	epatch "${FILESDIR}/${P}+gcc-4.7.patch"
	# bug #280887
	epatch "${FILESDIR}/${P}-configure.ac.patch"

	# bug #241954
	intltoolize --force
	eautoreconf
}

src_configure() {
	local myconf="$(use_enable doc documents)"
	# '--disable-*-immodule' are b0rked, bug #280887

	if use gtk ; then
		myconf="${myconf} --enable-gtk2-immodule=yes"
	else
		myconf="${myconf} --enable-gtk2-immodule=no"
	fi

	# Qt3 is no longer supported, bug 283429
	myconf="${myconf} --enable-qt3-immodule=no"

	if use qt4 ; then
		myconf="${myconf} --enable-qt4-immodule=yes"
	else
		myconf="${myconf} --enable-qt4-immodule=no"
	fi

	econf ${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README || die
}

pkg_postinst() {
	elog
	elog "If you would like to use ${PN} as default instead of scim, set"
	elog " $ export GTK_IM_MODULE=scim-bridge"
	elog " $ export QT_IM_MODULE=scim-bridge"
	elog
	use gtk && gnome2_query_immodules_gtk2
}

pkg_postrm() {
	use gtk && gnome2_query_immodules_gtk2
}
