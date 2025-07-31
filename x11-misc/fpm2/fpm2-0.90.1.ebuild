# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature xdg

DESCRIPTION="A GUI password manager utility with password generator"
HOMEPAGE="https://als.regnet.cz/fpm2/"
SRC_URI="https://als.regnet.cz/${PN}/download/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2:=
	dev-libs/nettle:=
	x11-libs/gtk+:3[X]
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.90.1-fix_bashism.patch
)

src_prepare() {
	default
	# gettext make check failure
	echo "data/fpm2.desktop.in" >> po/POTFILES.in || die

	# only because fix_bashism.patch
	eautoreconf
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "web launcher defined by default" x11-misc/xdg-utils
}
