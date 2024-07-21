# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop

DESCRIPTION="A cool Jump'n Run game offering some unique visual effects"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	mirror://debian/pool/main/a/amphetamine-data/amphetamine-data_0.8.7.orig.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${PN}.png
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

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
	"${FILESDIR}"/${P}-format-string.patch

	# From OpenBSD:
	"${FILESDIR}"/${P}-SDL-conversions.patch
	"${FILESDIR}"/${P}-clang.patch

	"${FILESDIR}"/${P}-drop-register-keyword.patch
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
	doicon "${DISTDIR}/${PN}.png"
	make_desktop_entry ${PN} Amphetamine ${PN}
	einstalldocs
}
