# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils gnome2-utils multilib nsplugins xdg-utils

DESCRIPTION="GTK+ Front-End for libxine"
HOMEPAGE="http://xine.sourceforge.net/"
SRC_URI="mirror://sourceforge/xine/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="l10n_cs l10n_de lirc nls nsplugin udev +xcb xinerama"

COMMON_DEPEND=">=media-libs/xine-lib-1.1.20[gtk]
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
	udev? ( dev-libs/libgudev:= )
	xcb? ( x11-libs/libxcb )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
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

	use l10n_cs && dodoc README.cs
	use l10n_de && dodoc README.de

	use nsplugin && inst_plugin /usr/$(get_libdir)/gxine/gxineplugin.so
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
