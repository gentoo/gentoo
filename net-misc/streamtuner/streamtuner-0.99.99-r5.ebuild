# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Stream directory browser for browsing internet radio streams"
HOMEPAGE="https://www.nongnu.org/streamtuner/"
SRC_URI="https://savannah.nongnu.org/download/${PN}/${P}.tar.gz
	 https://savannah.nongnu.org/download/${PN}/${P}-pygtk-2.6.diff"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="+shout +xiph"

RDEPEND="
	>=x11-libs/gtk+-2.4:2
	net-misc/curl
	xiph? ( dev-libs/libxml2:2 )
	>=media-libs/taglib-1.2
	x11-misc/xdg-utils
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
"

src_prepare() {
	eapply "${FILESDIR}"/${P}-gentoo.patch
	eapply "${FILESDIR}"/${P}-shoutcast.patch
	eapply "${FILESDIR}"/${P}-shoutcast-2.patch
	eapply "${FILESDIR}"/${P}-audacious.patch
	eapply -p0 "${DISTDIR}"/${P}-pygtk-2.6.diff
	eapply "${FILESDIR}"/${P}-stack_increase.patch

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
		--disable-python \
		$(use_enable shout shoutcast) \
		$(use_enable xiph)
}
