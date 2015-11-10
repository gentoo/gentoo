# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A small, fast, full-featured window manager for X"
HOMEPAGE="http://blackboxwm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}wm/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="nls truetype debug"

RDEPEND="x11-libs/libXft
	x11-libs/libXt
	nls? ( sys-devel/gettext )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-apps/sed-4
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.3.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-no-LDFLAGS-pc.patch

	sed -i -e "s/_XUTIL_H_/_X11&/" lib/Util.hh || die #348556
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/X11/${PN} \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable truetype xft)
}

src_install() {
	dodir /etc/X11/Sessions
	echo "/usr/bin/blackbox" > "${D}/etc/X11/Sessions/${PN}"
	fperms a+x /etc/X11/Sessions/${PN}

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"

	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog* COMPLIANCE README* TODO

	prune_libtool_files --all
}
