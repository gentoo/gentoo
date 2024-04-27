# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="The best way to make beautiful and functional wayland widgets"
HOMEPAGE="https://github.com/Aylur/ags"

MY_PV="v$PV"

SRC_URI="
https://github.com/Aylur/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz
https://github.com/Aylur/${PN}/releases/download/${MY_PV}/node_modules-${MY_PV}.tar.gz -> ${P}_node_modules.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="battery bluetooth fetch greetd network notifications power-profiles system-tray +types"

DEPEND="
	dev-libs/glib:2
	>=dev-libs/gjs-1.73.1
	virtual/libc
	sys-libs/pam
	gui-libs/gtk-layer-shell:0[introspection]
	media-libs/libpulse[glib,gtk]
	x11-libs/gtk+:3[wayland,introspection]
"

BDEPEND="
	${DEPEND}
	dev-lang/typescript
	>=dev-build/meson-0.62.0
	>=dev-libs/gobject-introspection-1.49.1
"

RDEPEND="
	${DEPEND}
	battery? ( sys-power/upower )
	bluetooth? ( net-wireless/gnome-bluetooth )
	fetch? ( net-libs/libsoup:3.0[introspection] )
	greetd? ( gui-libs/greetd )
	notifications? ( x11-libs/libnotify )
	network? ( net-misc/networkmanager[introspection] )
	power-profiles? ( sys-power/power-profiles-daemon )
	system-tray? ( dev-libs/libdbusmenu[gtk3,introspection] )
"

BUILD_DIR="${S}/build"

src_unpack() {
	# Unpack the src files into ${S} instead of ${DISTDIR}/ags
	unpack ${P}.tar.gz
	mv ${PN} "${S}"
	# Unpack the node modules into the src folder.
	unpack "${P}_node_modules.tar.gz"
	mv node_modules "${S}"
}

src_configure() {
	local emesonargs=(
		$(meson_use types build_types)
	)
	meson_src_configure --libdir "lib/${PN}"
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
	# Set the node module install location to the app dir.
	instinto "${EPREFIX}"/usr/share/com.github.Aylur.ags/
	# Copy packaged NodeJS modules there.
	doins -r "node_modules" || die
	# Create a symlink for the executable
	dosym -r "${EPREFIX}"/usr/share/com.github.Aylur.ags/com.github.Aylur.ags "${EPREFIX}"/usr/bin/ags || die
}

pkg_postinst() {
	elog "To learn on how to use ags, please read"
	elog "https://aylur.github.io/ags-docs/"
	elog "which describes its usage and configuration."
}
