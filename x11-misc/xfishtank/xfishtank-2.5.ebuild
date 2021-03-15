# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Turns your root window into an aquarium"
HOMEPAGE="https://jim.rees.org/computers/xfishtank.html"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-linux"

RDEPEND="
	media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	x11-misc/imake
"
S=${WORKDIR}/${PN}

src_configure() {
	xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		${PN}
}
