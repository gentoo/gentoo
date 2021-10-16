# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools vcs-snapshot

DESCRIPTION="Very simple layout switcher"
HOMEPAGE="https://github.com/qnikst/kbdd"
SRC_URI="https://github.com/qnikst/kbdd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

RDEPEND="
	dev-libs/glib:2
	x11-libs/libX11
	dbus? (
		sys-apps/dbus
		dev-libs/dbus-glib
	)"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils" #669674

PATCHES=( "${FILESDIR}"/${P}-AM_PROG_AR.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable dbus)
}
