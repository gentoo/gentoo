# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson udev

DESCRIPTION="library to add support for consumer fingerprint readers"
HOMEPAGE="https://cgit.freedesktop.org/libfprint/libfprint/ https://github.com/freedesktop/libfprint https://gitlab.freedesktop.org/libfprint/libfprint"
SRC_URI="https://gitlab.freedesktop.org/libfprint/libfprint/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"

RDEPEND="dev-libs/glib:2
	dev-libs/nss
	>=dev-libs/libgusb-0.3.1
	virtual/libusb:1=
	x11-libs/gtk+:3
	x11-libs/pixman
	x11-libs/libX11
	x11-libs/libXv"

DEPEND="${RDEPEND}
	dev-util/gtk-doc"

BDEPEND="virtual/pkgconfig"

PATCHES=( ${FILESDIR}/${PN}-0.8.2-fix-implicit-declaration.patch )

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
		local emesonargs=(
			-Ddoc=false
			-Dgtk-examples=$(usex examples true false)
			-Ddrivers=all
			-Dudev_rules=true
			-Dudev_rules_dir=$(get_udevdir)/rules.d
			--libdir=/usr/$(get_libdir)
		)
		meson_src_configure
}
