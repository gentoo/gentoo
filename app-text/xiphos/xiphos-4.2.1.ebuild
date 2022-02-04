# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="A Gtk+-based Bible-study frontend for SWORD"
HOMEPAGE="https://xiphos.org/"
SRC_URI="https://github.com/crosswire/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.1 LGPL-2 MIT MPL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE="dbus debug"

COMMON="sys-apps/util-linux
	dev-libs/libxml2
	dev-libs/libxslt
	dbus? ( dev-libs/dbus-glib )"
RDEPEND="${COMMON}
	>=app-text/sword-1.8.1
	dev-libs/glib:2
	dev-libs/icu
	gnome-extra/gtkhtml:4.0
	>=net-libs/biblesync-1.2.0
	net-libs/webkit-gtk:4
	sys-libs/zlib[minizip]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="${COMMON}
	app-arch/zip
	app-text/yelp-tools
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	dev-util/glib-utils
	dev-util/itstool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.2.1-appdata_metainfo.patch
	"${FILESDIR}"/${PN}-4.2.1-glib_version_min_required.patch
)

src_configure() {
	# TODO: stop using gtkhtml, it is deprecated (Bug #667914). However, as
	# of 4.2.1 it is still required because the WebKit-based editor
	# does not support webkit-gtk:4.
	local mycmakeargs=(
		-DDBUS=$(usex dbus)
		-DDEBUG=$(usex debug)
		-DGTKHTML=on
		-DPOSTINST=off
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
