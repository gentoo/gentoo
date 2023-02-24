# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="A Gtk+-based Bible-study frontend for SWORD"
HOMEPAGE="https://xiphos.org/"
SRC_URI="https://github.com/crosswire/${PN}/releases/download/${PV}/${P}.tar.xz
	https://dev.gentoo.org/~marecki/dists/${CATEGORY}/${PN}/${PN}-4.2.1-disable_webkit_editor.patch.xz"

LICENSE="GPL-2 FDL-1.1 LGPL-2 MIT MPL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus debug"

COMMON="sys-apps/util-linux
	dev-libs/libxml2
	dev-libs/libxslt
	dbus? ( dev-libs/dbus-glib )"
RDEPEND="${COMMON}
	>=app-text/sword-1.8.1
	dev-libs/glib:2
	dev-libs/icu
	>=net-libs/biblesync-1.2.0
	net-libs/webkit-gtk:4.1
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
	"${WORKDIR}"/${PN}-4.2.1-disable_webkit_editor.patch
	"${FILESDIR}"/${PN}-4.2.1-appdata_metainfo.patch
	"${FILESDIR}"/${PN}-4.2.1-glib_version_min_required.patch
	"${FILESDIR}"/${PN}-4.2.1-webkit41.patch
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
	xdg_icon_cache_update

	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		local rver
		for rver in ${REPLACING_VERSIONS}; do
			if ver_test "${rver}" -le "4.2.1"; then
				ewarn "Please note that ${PN} no longer provides an editor due to its dependency on outdated libraries."
				ewarn "Studypad and the personal commentary will no longer work."
				break
			fi
		done
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
