# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
inherit autotools fdo-mime flag-o-matic gnome2-utils python-single-r1

DESCRIPTION="Graphical IRC client based on XChat"
HOMEPAGE="https://hexchat.github.io/"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://dl.hexchat.net/${PN}/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 sparc x86 ~amd64-linux"
fi

LICENSE="GPL-2 plugin-fishlim? ( MIT )"
SLOT="0"
IUSE="dbus debug +gtk libcanberra libnotify libproxy libressl lua nls perl plugin-checksum plugin-fishlim plugin-sysinfo python spell ssl"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="dev-libs/glib:2
	dbus? ( sys-apps/dbus )
	gtk? ( x11-libs/gtk+:2 )
	libcanberra? ( media-libs/libcanberra )
	libproxy? ( net-libs/libproxy )
	libnotify? ( x11-libs/libnotify )
	lua? ( dev-lang/lua:= )
	nls? ( virtual/libintl )
	perl? ( dev-lang/perl:= )
	plugin-sysinfo? ( sys-apps/pciutils )
	python? ( ${PYTHON_DEPS} )
	spell? ( app-text/iso-codes )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"

RDEPEND="${COMMON_DEPEND}
	spell? ( app-text/enchant )"
DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/autoconf-archive"

PATCHES=(
	"${FILESDIR}/hexchat-2.12.4-configure.ac.patch"
	"${FILESDIR}/hexchat-2.12.4-libressl.patch"
)

src_prepare() {
	default
	eautoreconf
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	append-cflags \
		$(test-flags-CC -Wno-error=format-security) \
		$(test-flags-CC -Wno-error=init-self) \
		$(test-flags-CC -Wno-error=declaration-after-statement) \
		$(test-flags-CC -Wno-error=missing-include-dirs) \
		$(test-flags-CC -Wno-error=date-time) \
		$(test-flags-CC -Wno-error=implicit-function-declaration) \
		$(test-flags-CC -Wno-error=pointer-arith)

	econf \
		--enable-plugin \
		$(use_enable nls) \
		$(use_enable ssl openssl) \
		$(use_enable gtk gtkfe) \
		$(use_enable !gtk textfe) \
		$(use_enable python python "${EPYTHON}") \
		$(use_enable perl) \
		$(use_enable plugin-checksum checksum) \
		$(use_enable plugin-fishlim fishlim) \
		$(use_enable plugin-sysinfo sysinfo) \
		$(use_enable dbus) \
		$(use_enable lua) \
		$(use_enable libnotify) \
		$(use_enable libcanberra) \
		$(use_enable libproxy) \
		$(use_enable spell isocodes) \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" \
		UPDATE_ICON_CACHE=true \
		UPDATE_MIME_DATABASE=true \
		UPDATE_DESKTOP_DATABASE=true \
		install
	dodoc readme.md
	find "${D}" -name '*.la' -delete || die
}

pkg_preinst() {
	if use gtk ; then
		gnome2_icon_savelist
	fi
}

pkg_postinst() {
	if use gtk ; then
		gnome2_icon_cache_update
	else
		elog "You have disabled the gtk USE flag. This means you don't have"
		elog "the GTK-GUI for HexChat but only a text interface called \"hexchat-text\"."
	fi

	elog
	elog "optional dependencies:"
	elog "  media-sound/sox (sound playback if you don't have libcanberra"
	elog "    enabled)"
	elog "  x11-plugins/hexchat-javascript (javascript support)"
	elog "  x11-themes/sound-theme-freedesktop (default BEEP sound,"
	elog "    needs libcanberra enabled)"
}

pkg_postrm() {
	if use gtk ; then
		gnome2_icon_cache_update
	fi
}
