# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Game about an evil hacker called Bill!"
HOMEPAGE="http://www.xbill.org/"
SRC_URI="
	http://www.xbill.org/download/${P}.tar.gz
	https://dashboard.snapcraft.io/site_media/appmedia/2018/04/xbill.png"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-fonts/font-misc-misc
	x11-libs/libXaw"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		--disable-motif
		--disable-gtk
		--enable-athena
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} XBill ${PN}

	fowners :gamestat /var/lib/xbill/scores /usr/bin/${PN}
	fperms 664 /var/lib/xbill/scores
}
