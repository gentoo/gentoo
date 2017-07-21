# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils python-single-r1

DESCRIPTION="A Bluetooth configuration tool"
HOMEPAGE="https://github.com/linuxmint/blueberry"
SRC_URI="https://github.com/linuxmint/blueberry/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=net-wireless/gnome-bluetooth-3.14[introspection]
	net-wireless/rfkill
	x11-misc/wmctrl"
DEPEND="${RDEPEND}"

src_prepare () {
	sed -i 's@^#!.*python$@#!/usr/bin/python2@' usr/bin/blueberry{,-tray} || die
	epatch_user
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
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	gnome2_icon_cache_update
}
