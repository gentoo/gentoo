# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper

DESCRIPTION="Very fast and lightweight still powerful window manager for X"
HOMEPAGE="http://joewing.net/projects/jwm/"
SRC_URI="https://github.com/joewing/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="svg debug iconv jpeg nls png pango truetype xinerama xpm"

RDEPEND="dev-libs/expat
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXrender
	svg? (
		x11-libs/cairo
		gnome-base/librsvg
	)
	iconv? ( virtual/libiconv )
	jpeg? ( media-libs/libjpeg-turbo )
	nls? ( sys-devel/gettext
		virtual/libintl )
	pango? ( x11-libs/pango )
	png? ( media-libs/libpng:0= )
	truetype? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable svg cairo) \
		$(use_enable svg rsvg) \
		$(use_enable debug) \
		$(use_enable jpeg) \
		$(use_enable nls) \
		$(use_enable pango) \
		$(use_enable png) \
		$(use_enable truetype xft) \
		$(use_enable xinerama) \
		$(use_enable xpm) \
		$(use_with iconv libiconv-prefix /usr) \
		$(use_with nls libintl-prefix /usr) \
		--enable-shape \
		--enable-xrender \
		--disable-rpath
}

src_install() {
	dodir /etc
	dodir /usr/bin
	dodir /usr/share/man

	default

	make_wrapper "${PN}" "/usr/bin/${PN}" "" "" "/etc/X11/Sessions"

	insinto "/usr/share/xsessions"
	doins "${FILESDIR}"/jwm.desktop

	dodoc README.md README.upgrading example.jwmrc CONTRIBUTING.md
}

pkg_postinst() {
	einfo "JWM can be configured system-wide with ${EROOT}/etc/system.jwmrc"
	einfo "or per-user by creating a configuration file in ~/.jwmrc"
	einfo
	einfo "An example file can be found in ${EROOT}/usr/share/doc/${PF}/"
}
