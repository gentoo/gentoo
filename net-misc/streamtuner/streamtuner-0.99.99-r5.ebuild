# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/streamtuner/streamtuner-0.99.99-r5.ebuild,v 1.6 2013/09/27 22:18:18 pacho Exp $

EAPI=5
GCONF_DEBUG=no
inherit eutils gnome2

DESCRIPTION="Stream directory browser for browsing internet radio streams"
HOMEPAGE="http://www.nongnu.org/streamtuner"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz
	 http://savannah.nongnu.org/download/${PN}/${P}-pygtk-2.6.diff"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="python +shout +xiph"

RDEPEND="
	>=x11-libs/gtk+-2.4:2
	net-misc/curl
	app-text/scrollkeeper
	xiph? ( dev-libs/libxml2:2 )
	>=media-libs/taglib-1.2
	python? ( dev-python/pygtk:2 )
	x11-misc/xdg-utils
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-shoutcast.patch \
		"${FILESDIR}"/${P}-shoutcast-2.patch \
		"${FILESDIR}"/${P}-audacious.patch \
		"${DISTDIR}"/${P}-pygtk-2.6.diff \
		"${FILESDIR}"/${P}-stack_increase.patch

	# Fix .desktop file
	sed -i \
		-e 's/streamtuner.png/streamtuner/' \
		-e 's/Categories=Application;/Categories=/' \
		data/streamtuner.desktop.in || die

	gnome2_src_prepare
}

src_configure() {
	# live365 causes parse errors at connect time
	# The right value for compile-warning for this is 'yes' (#481124)
	gnome2_src_configure \
		--enable-compile-warnings=yes \
		--disable-live365 \
		$(use_enable python) \
		$(use_enable shout shoutcast) \
		$(use_enable xiph)
}
