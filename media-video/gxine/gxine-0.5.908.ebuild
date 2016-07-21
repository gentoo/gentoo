# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils fdo-mime gnome2-utils multilib nsplugins

DESCRIPTION="GTK+ Front-End for libxine"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="linguas_cs linguas_de lirc nls nsplugin udev +xcb xinerama"

COMMON_DEPEND=">=media-libs/xine-lib-1.1.20
	x11-libs/gtk+:2
	>=dev-libs/glib-2
	>=dev-lang/spidermonkey-1.8.2.15:0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	lirc? ( app-misc/lirc )
	nls? ( virtual/libintl )
	nsplugin? ( dev-libs/nspr
		x11-libs/libXaw
		x11-libs/libXt )
	udev? ( virtual/libgudev:= )
	xcb? ( x11-libs/libxcb )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	# ld: cannot find -ljs
	sed -i -e '/JS_LIBS="`spidermonkey_locate_lib/s:js:mozjs:' m4/_js.m4 || die

	if has_version '>=dev-lang/spidermonkey-1.8.7:0'; then
		sed -i -e 's:mozjs185:mozjs187:' m4/_js.m4 || die #422983
	fi

	epatch \
		"${FILESDIR}"/${PN}-0.5.905-desktop.patch \
		"${FILESDIR}"/${PN}-0.5.905-fix-nspr-useage.patch \
		"${FILESDIR}"/${PN}-0.5.906-endif.patch \
		"${FILESDIR}"/${PN}-0.5.907-underlinking.patch

	# need to disable calling of xine-list when running without
	# userpriv, otherwise we get sandbox violations (bug #233847)
	if [[ ${EUID} == "0" ]]; then
		sed -i -e 's:^XINE_LIST=.*$:XINE_LIST=:' configure.ac || die
	fi

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable lirc) \
		--enable-watchdog \
		$(use_with xcb) \
		$(has_version '<dev-lang/spidermonkey-1.8.5' && echo --with-spidermonkey=/usr/include/js) \
		$(use_with nsplugin browser-plugin) \
		$(use_with udev gudev) \
		--without-hal \
		--without-dbus \
		$(use_with xinerama)
}

src_install() {
	emake DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		docsdir=/usr/share/doc/${PF} \
		install

	dodoc AUTHORS BUGS ChangeLog README{,_l10n} TODO

	use linguas_cs && dodoc README.cs
	use linguas_de && dodoc README.de

	use nsplugin && inst_plugin /usr/$(get_libdir)/gxine/gxineplugin.so
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
