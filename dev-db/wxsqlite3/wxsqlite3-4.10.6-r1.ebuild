# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit autotools wxwidgets

DESCRIPTION="C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://wxcode.sourceforge.net/components/wxsqlite3/"
SRC_URI="https://github.com/utelle/wxsqlite3/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}=[X]
	dev-db/sqlite:3="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets

	econf --with-wx-config="${WX_CONFIG}"
}

src_install() {
	default
	dodoc readme.md

	find "${ED}" -type f -name '*.la' -delete || die
}
