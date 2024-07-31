# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop toolchain-funcs

PATCH_LEVEL="4"

DESCRIPTION="USB Video Class grabber"
HOMEPAGE="https://packages.qa.debian.org/l/luvcview.html"
SRC_URI="mirror://debian/pool/main/l/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/l/${PN}/${PN}_${PV}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl
	media-libs/libv4l
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	eapply "${WORKDIR}"/${PN}_${PV}-${PATCH_LEVEL}.diff
	eapply debian/patches/*.patch
	sed -i -e 's:videodev.h:videodev2.h:' *.{c,h} || die
	sed -i -e 's:-O2::' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC) ${LDFLAGS}"
}

src_install() {
	dobin luvcview
	doman debian/luvcview.1
	dodoc Changelog README ToDo
	make_desktop_entry ${PN}
}
