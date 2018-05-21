# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Dockapp mixer for OSS or ALSA"
HOMEPAGE="https://www.dockapps.net/wmix"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/dockapps

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman "${FILESDIR}"/${PN}.1
	dodoc AUTHORS BUGS NEWS README sample.wmixrc
}
