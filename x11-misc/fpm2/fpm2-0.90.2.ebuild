# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature xdg

DESCRIPTION="GUI password manager utility with password generator"
HOMEPAGE="https://als.regnet.cz/fpm2/"
SRC_URI="https://als.regnet.cz/${PN}/download/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:=
	dev-libs/nettle:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "web launcher defined by default" x11-misc/xdg-utils
}
