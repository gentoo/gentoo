# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Famous german card game"
HOMEPAGE="http://www.xskat.de/xskat.html"
SRC_URI="
	http://www.xskat.de/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

COMMON_DEPEND="x11-libs/libX11"
RDEPEND="
	${COMMON_DEPEND}
	media-fonts/font-misc-misc"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() { :; }

src_compile() {
	tc-export CC
	append-cflags -std=gnu89 # old codebase, will break with c2x

	local emakeargs=(
		CFLAGS="${CFLAGS} ${CPPFLAGS} $($(tc-getPKG_CONFIG) --cflags x11 || die)"
		CPPFLAGS= # force everywhere above, but avoid implicit duplication
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
