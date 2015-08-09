# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools bash-completion-r1 eutils

DESCRIPTION="A fast, lightweight quick launch bar"
HOMEPAGE="http://code.google.com/p/wbar/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gtk"

RDEPEND="media-libs/imlib2[X]
	x11-libs/libX11
	gtk? ( gnome-base/libglade
		media-libs/freetype:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	use gtk || epatch "${FILESDIR}"/${PN}-2.3.3-cfg.patch
	epatch \
		"${FILESDIR}"/${PN}-2.3.3-desktopfile.patch \
		"${FILESDIR}"/${PN}-2.3.3-nowerror.patch \
		"${FILESDIR}"/${PN}-2.3.3-test.patch \
		"${FILESDIR}"/${P}-automake-1.13.patch

	sed -i \
		-e "/^bashcompletiondir/s:=.*$:=$(get_bashcompdir):" \
		etc/Makefile.am || die #482358

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk wbar-config)
}

pkg_postinst() {
	einfo
	elog "media-libs/imlib2 needs to be compiled with the appropriate useflags"
	elog "depending on your choice of image files (such as png, jpeg...)"
	einfo
}
