# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake eapi9-ver xdg

DESCRIPTION="Gtk+-based Bible-study frontend for SWORD"
HOMEPAGE="https://xiphos.org/"
SRC_URI="https://github.com/crosswire/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus debug"

RDEPEND="
	app-text/sword
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/libxml2:=
	net-libs/biblesync
	net-libs/webkit-gtk:4.1
	sys-libs/zlib[minizip]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	dbus? ( dev-libs/dbus-glib )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-arch/zip
	app-text/yelp-tools
	dev-libs/appstream-glib
	dev-libs/libxslt
	dev-util/desktop-file-utils
	dev-util/glib-utils
	dev-util/itstool
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.2-include_dbus.patch
	# merged. to be removed at next version
	"${FILESDIR}"/${PN}-4.3.2-fix_odr.patch
)

src_configure() {
	local mycmakeargs=(
		-DDBUS=$(usex dbus)
		-DDEBUG=$(usex debug)
		-DPOSTINST=off
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst

	# see https://github.com/crosswire/xiphos/blob/4.3.2/src/editor/webkit_editor.c#L28
	if ver_replacing -le "4.2.1"; then
		ewarn "Please note that ${PN} no longer provides an editor due to its dependency on outdated libraries."
		ewarn "Studypad and the personal commentary will no longer work."
	fi
}
