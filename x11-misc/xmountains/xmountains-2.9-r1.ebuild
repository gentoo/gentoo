# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Fractal terrains of snow-capped mountains near water"
HOMEPAGE="https://spbooth.github.io/xmountains/"
SRC_URI="http://www.epcc.ed.ac.uk/~spb/${PN}/${P/-/_}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-misc/xbitmaps
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.9-fno-common.patch
	"${FILESDIR}"/${PN}-2.9-global.patch
	"${FILESDIR}"/${PN}-2.9-main.patch
	"${FILESDIR}"/${PN}-2.9-string.patch
)
S=${WORKDIR}

src_compile() {
	emake \
		-f Makefile.alt \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${CFLAGS} ${LDFLAGS}" \
		${PN}
}

src_install() {
	dobin ${PN}
	newman ${PN}.man ${PN}.1
	einstalldocs
}
