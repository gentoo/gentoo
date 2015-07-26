# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/roccat-tools/roccat-tools-3.4.0.ebuild,v 1.1 2015/07/22 01:44:28 idella4 Exp $

EAPI=5

inherit readme.gentoo cmake-utils gnome2-utils udev user

DESCRIPTION="Utility for advanced configuration of Roccat devices"

HOMEPAGE="http://roccat.sourceforge.net/"
SRC_URI="mirror://sourceforge/roccat/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_INPUT_DEVICES="
	input_devices_roccat_arvo
	input_devices_roccat_isku
	input_devices_roccat_iskufx
	input_devices_roccat_kone
	input_devices_roccat_koneplus
	input_devices_roccat_konepure
	input_devices_roccat_konepuremilitary
	input_devices_roccat_konepureoptical
	input_devices_roccat_konextd
	input_devices_roccat_konextdoptical
	input_devices_roccat_kovaplus
	input_devices_roccat_lua
	input_devices_roccat_pyra
	input_devices_roccat_savu
	input_devices_roccat_ryosmk
	input_devices_roccat_ryostkl
	input_devices_roccat_tyon
"
IUSE="${IUSE_INPUT_DEVICES} lua"
REQUIRED_USE="
	lua? ( input_devices_roccat_ryosmk )
"

RDEPEND="
	>=dev-libs/libgaminggear-0.10
	x11-libs/gtk+:2
	x11-libs/libnotify
	media-libs/libcanberra
	virtual/libusb:1
	dev-libs/dbus-glib
	virtual/libgudev:=
	lua? ( || ( dev-lang/lua:5.1 dev-lang/lua:0 ) )
"

DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup roccat
}

src_configure() {
	local UDEVDIR="$(get_udevdir)"/rules.d
	local MODELS=${INPUT_DEVICES//roccat_/}
	mycmakeargs=(
		-DDEVICES=${MODELS// /;} \
		-DUDEVDIR="${UDEVDIR/"//"//}"
	)
	if use lua ; then
		mycmakeargs+=( -DWITH_LUA=5.1 )
	fi
	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install
	local stat_dir=/var/lib/roccat
	keepdir $stat_dir
	fowners root:roccat $stat_dir
	fperms 2770 $stat_dir
	readme.gentoo_src_install
}
pkg_preinst() {
	gnome2_icon_savelist
}
pkg_postinst() {
	gnome2_icon_cache_update
	readme.gentoo_print_elog
	ewarn
	ewarn "Starting from version 3.0.0, executables were renamed and now prefixed with 'roccat',"
	ewarn "so konextdconfig is now roccatkonextdconfig and so on"
	ewarn "Everything that was ryos is now ryosmk to distinguish it from the ryostkl product range"
	ewarn
}

pkg_postrm() {
	gnome2_icon_cache_update
}
