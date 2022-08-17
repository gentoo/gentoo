# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
inherit cmake wxwidgets

DESCRIPTION="ARRL Logbook of the World"
HOMEPAGE="https://www.arrl.org/tqsl-download"
SRC_URI="https://www.arrl.org/${PN}/${P}.tar.gz"

LICENSE="LOTW"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/expat:=
	dev-libs/openssl:0=
	net-misc/curl:=
	dev-db/lmdb:=
	sys-libs/zlib:=
	x11-libs/wxGTK:${WX_GTK_VER}="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS.txt INSTALL README )
HTML_DOCS=( html/. )

src_configure() {
	setup-wxwidgets
	cmake_src_configure
}
