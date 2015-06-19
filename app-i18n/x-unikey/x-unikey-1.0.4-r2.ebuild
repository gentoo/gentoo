# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/x-unikey/x-unikey-1.0.4-r2.ebuild,v 1.2 2015/04/21 02:22:53 patrick Exp $

EAPI=5

inherit autotools eutils multilib gnome2-utils

DESCRIPTION="Vietnamese X Input Method"
HOMEPAGE="http://www.unikey.org/"
SRC_URI="mirror://sourceforge/unikey/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls gtk"

RDEPEND="x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE
	gtk? ( >=x11-libs/gtk+-2.2:2 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-libs/glib
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0/}
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_configure() {
	local myconf
	# --with-gtk-sysconfdir to prevent sandbox violation only
	use gtk && myconf="--with-unikey-gtk --with-gtk-sysconfdir=${GTK2_CONFDIR}"
	econf ${myconf}
}

src_install() {
	if use gtk;then
		dodir "${GTK2_CONFDIR}"
#		emake DESTDIR="${D}" install -C src/unikey-gtk || die
	fi
#	dobin src/xim/ukxim src/gui/unikey
	emake DESTDIR="${D}" install
	doenvd "${FILESDIR}/01x-unikey"

	dodoc AUTHORS CREDITS ChangeLog NEWS README TODO
	cd doc
	dodoc README1ST keymap-syntax manual options ukmacro \
		unikey-manual-0.9.pdf unikey.png unikeyrc
}

pkg_postinst() {
	elog
	elog "Go to /etc/env.d/01x-unikey and uncomment appropriate lines"
	elog "to enable x-unikey"
	elog
	if use gtk; then
		gnome2_query_immodules_gtk2
		elog "If you want to use x-unikey as the default gtk+ input method,"
		elog "change GTK_IM_MODULE in /etc/env.d/01x-unikey to \"unikey\""
		elog
	fi
}

pkg_postrm() {
	use gtk && gnome2_query_immodules_gtk2
}
