# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WindowMaker/AfterStep system monitor dockapp"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://debian/pool/main/a/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"

RDEPEND="
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	default

	sed -i -e "s:gcc:$(tc-getCC):g" Makefile || die

	cd "../wmgeneral" || die
	eapply "${FILESDIR}/${P}-list.patch"
	eapply "${FILESDIR}/${P}-fno-common.patch"
}

src_compile() {
	emake clean
	emake SOLARIS="${CFLAGS}" LIBDIR="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ../Changelog
}
