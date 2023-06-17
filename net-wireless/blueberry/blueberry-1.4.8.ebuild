# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="A Bluetooth configuration tool"
HOMEPAGE="https://github.com/linuxmint/blueberry"
SRC_URI="https://github.com/linuxmint/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/python3-xapp[${PYTHON_USEDEP}]
	')
	>=net-wireless/gnome-bluetooth-3.14:2[introspection]
	net-wireless/bluez[obex]
	net-wireless/bluez-tools
	>=sys-apps/util-linux-2.31_rc1
	x11-libs/libnotify[introspection]
	x11-misc/wmctrl
"
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

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
