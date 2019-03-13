# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="a terminal emulator based off of libvte that aims to be fast and lightweight"
HOMEPAGE="https://lilyterm.luna.com.tw"
LICENSE="GPL-3"
SRC_URI="https://${PN}.luna.com.tw/file/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/vte:0
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog README TODO )
PATCHES=(
	"${FILESDIR}"/${PN}-0.9.9.4-autogen.patch
	"${FILESDIR}"/${PN}-0.9.9.4-gettext.patch
)

src_prepare() {
	default

	./autogen.sh || die
	eautoreconf
}
