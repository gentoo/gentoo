# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2-utils

DESCRIPTION="Nimf is a lightweight, fast and extensible input method framework"
HOMEPAGE="https://github.com/hamonikr/nimf"
SRC_URI="https://github.com/hamonikr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+anthy +rime m17n-lib hardening"

CDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libxklavier
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/gtk+:2
	x11-libs/gtk+:3
	dev-libs/libappindicator:3
	dev-qt/qtgui:5
	x11-libs/libxkbcommon
	gnome-base/librsvg
	dev-libs/glib:2
	app-i18n/libhangul
	rime? ( app-i18n/librime )
	m17n-lib? ( dev-libs/m17n-lib )
	anthy? ( app-i18n/anthy )
	dev-libs/wayland
	dev-libs/wayland-protocols
"

RDEPEND="
	${CDEPEND}
"

DEPEND="
	${CDEPEND}
	dev-util/intltool
	sys-devel/gettext
	x11-base/xorg-proto
"

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

src_prepare() {
	default

	eapply "${FILESDIR}"/${PN}-drop-qt4.patch
}

src_configure() {
	local myconf=""

	use rime || myconf+=" --disable-nimf-rime"
	use m17n-lib || myconf+=" --disable-nimf-m17n"
	use anthy || myconf+=" --disable-nimf-anthy"
	use hardening || myconf+=" --disable-hardening"

	sh autogen.sh \
		--prefix="${EPREFIX}/usr" \
		--bindir="${EPREFIX}/usr/bin" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--datadir="${EPREFIX}/usr/share/nimf${namesuf}" \
		--mandir="${EPREFIX}/usr/share/man" \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
