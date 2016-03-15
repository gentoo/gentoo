# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="A newsreader for GNOME"
HOMEPAGE="http://pan.rebelbase.com/"
SRC_URI="http://pan.rebelbase.com/download/releases/${PV}/source/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="dbus gnome-keyring libnotify spell ssl"

RDEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-2.16:2
	dev-libs/gmime:2.6
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3.2 )
	libnotify? ( >=x11-libs/libnotify-0.4.1:0= )
	spell? (
		>=app-text/enchant-1.6
		>=app-text/gtkspell-2.0.7:2 )
	ssl? ( >=net-libs/gnutls-3:0= )"

DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	>=dev-util/intltool-0.35.5
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	# in next release
	epatch "${FILESDIR}/${P}-pan.desktop.patch"

	# g++-5 fix, https://bugzilla.gnome.org/show_bug.cgi?id=754698
	epatch "${FILESDIR}"/${PN}-0.139-get_pan_home.patch

	# Fix crash at startup: #570108
	epatch "${FILESDIR}"/${PN}-0.139-r2-fix_crash_at_startup.patch

	# upstream release was in 2012 - users may want to apply patches
	epatch_user
}

src_configure() {
	econf \
		--without-gtk3 \
		$(use_with dbus) \
		$(use_enable gnome-keyring gkr) \
		$(use_with spell gtkspell) \
		$(use_enable libnotify) \
		$(use_with ssl gnutls)
}
