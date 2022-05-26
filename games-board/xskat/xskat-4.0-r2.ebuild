# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Famous german card game"
HOMEPAGE="http://www.xskat.de/xskat.html"
SRC_URI="
	http://www.xskat.de/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND="x11-libs/libX11"
RDEPEND="
	${DEPEND}
	media-fonts/font-misc-misc"
BDEPEND="
	virtual/pkgconfig
	x11-base/xorg-proto"

src_configure() { :; }

src_compile() {
	tc-export CC

	local emakeargs=(
		CFLAGS="${CFLAGS} ${CPPFLAGS}"
		LDFLAGS="${LDFLAGS} $($(tc-getPKG_CONFIG) --libs x11 || die)"
	)

	emake "${emakeargs[@]}"
}

src_install() {
	dobin ${PN}
	newman ${PN}.{man,6}

	einstalldocs

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} XSkat
}
