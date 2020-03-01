# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop

DESCRIPTION="A cool Jump'n Run game offering some unique visual effects"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${PN}-data-0.8.6.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl[sound,video]
	x11-libs/libXpm
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-64bit.patch

	# From Debian:
	"${FILESDIR}"/${P}-no-lxt.patch
	"${FILESDIR}"/${P}-bugs.patch
	"${FILESDIR}"/${P}-missing-headers.patch
	"${FILESDIR}"/${P}-newline.patch
)

src_prepare() {
	default
	sed -i -e '55d' src/ObjInfo.cpp || die
}

src_compile() {
	emake INSTALL_DIR=/usr/share/${PN}
}

src_install() {
	newbin amph ${PN}
	insinto /usr/share/${PN}
	doins -r ../amph/*
	newicon amph.xpm ${PN}.xpm
	make_desktop_entry ${PN} Amphetamine ${PN}
	einstalldocs
}
