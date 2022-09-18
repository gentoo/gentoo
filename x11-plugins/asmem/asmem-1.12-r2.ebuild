# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Monitor the utilization level of memory, cache and swap space"
HOMEPAGE="http://www.tigr.net/"
SRC_URI="http://www.tigr.net/afterstep/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="jpeg"

RDEPEND="
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXpm
	x11-libs/libXext
	jpeg? ( media-libs/libjpeg-turbo:= )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/respect-ldflags.patch
	"${FILESDIR}"/configure-implicit-func-decls.patch
)

src_configure() {
	econf $(use_enable jpeg)
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	einstalldocs

	dobin ${PN}
	newman ${PN}.man ${PN}.1
}
