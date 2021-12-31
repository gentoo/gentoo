# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit eutils gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="A Bluetooth configuration tool"
HOMEPAGE="https://github.com/linuxmint/blueberry"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/xapp[${PYTHON_USEDEP}]
	>=net-wireless/gnome-bluetooth-3.14[introspection]
	net-wireless/bluez[obex]
	net-wireless/bluez-tools
	|| (
		>=sys-apps/util-linux-2.31_rc1
		net-wireless/rfkill
	)
	x11-libs/libnotify[introspection]
	x11-misc/wmctrl"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	python_fix_shebang usr/lib
}

src_install() {
	doins -r etc
	exeinto /usr/bin
	doexe usr/bin/*
	exeinto /usr/lib/blueberry
	doexe usr/lib/blueberry/*
	insinto /usr
	doins -r usr/share
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
