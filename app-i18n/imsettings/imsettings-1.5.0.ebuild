# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

DESCRIPTION="Delivery framework for general Input Method configuration"
HOMEPAGE="http://tagoh.github.com/imsettings/"
SRC_URI="https://bitbucket.org/tagoh/imsettings/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gconf gtk3 qt4 static-libs xfconf"

# X11 connections are required for test.
RESTRICT="test"

RDEPEND=">=dev-libs/check-0.9.4
	>=dev-libs/glib-2.26
	sys-apps/dbus
	>=x11-libs/gtk+-2.12:2
	>=x11-libs/libgxim-0.4.0
	>=x11-libs/libnotify-0.7
	x11-libs/libX11
	gconf? ( gnome-base/gconf )
	gtk3? ( x11-libs/gtk+:3 )
	qt4? ( dev-qt/qtcore:4 )
	xfconf? ( xfce-base/xfconf )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	doc? ( dev-util/gtk-doc )"

MY_XINPUTSH="90-xinput"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	# Prevent automagic linking to libxfconf-0.
	if ! use gconf; then
		sed -i -e 's:gconf-2.0:dIsAbLe&:' configure || die
	fi
	if ! use gtk3; then
		sed -i -e 's:gtk+-3.0:dIsAbLe&:' configure || die
	fi
	if ! use qt4; then
		sed -i -e 's:QtCore:dIsAbLe&:' configure || die
	fi
	if ! use xfconf; then
		sed -i -e 's:libxfconf-0:dIsAbLe&:' configure || die
	fi
	epatch "${FILESDIR}"/${P}-gir-scanner.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--with-xinputsh="${MY_XINPUTSH}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f '{}' +

	fperms 0755 /usr/libexec/xinputinfo.sh
	fperms 0755 "/etc/X11/xinit/xinitrc.d/${MY_XINPUTSH}"
}

pkg_postinst() {
	if [ ! -e "${EPREFIX}/etc/X11/xinit/xinputrc" ] ; then
		ln -sf xinput.d/xcompose.conf "${EPREFIX}/etc/X11/xinit/xinputrc"
	fi
}
