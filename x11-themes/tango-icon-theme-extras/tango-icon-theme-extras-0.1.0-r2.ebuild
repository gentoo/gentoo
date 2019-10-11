# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools eutils gnome2-utils

DESCRIPTION="Tango icons for iPod Digital Audio Player devices and the Dell Pocket DJ DAP"
HOMEPAGE="http://tango.freedesktop.org"
SRC_URI="http://tango.freedesktop.org/releases/${P}.tar.gz"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="png"

RDEPEND=">=x11-themes/tango-icon-theme-0.8.90"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=gnome-base/librsvg-2.34
	virtual/imagemagick-tools[png?]
	>=x11-misc/icon-naming-utils-0.8.90"

RESTRICT="binchecks strip"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-graphicsmagick.patch
	epatch "${FILESDIR}"/${P}-MKDIR_P.patch
	sed -i -e '/svgconvert_prog/s:rsvg:&-convert:' configure{,.ac} || die #413183
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable png png-creation) \
		$(use_enable png icon-framing)
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
