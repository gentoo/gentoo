# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="A GUI password manager utility with password generator"
HOMEPAGE="https://als.regnet.cz/fpm2/"
SRC_URI="https://als.regnet.cz/${PN}/download/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/nettle
	x11-libs/gtk+:3
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig"

src_prepare() {
	default
	# gettext make check failure
	echo "data/fpm2.desktop.in" >> po/POTFILES.in || die
}
