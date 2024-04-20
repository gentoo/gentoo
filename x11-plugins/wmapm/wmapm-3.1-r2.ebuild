# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WindowMaker DockApp: Battery/Power status monitor for laptops"
HOMEPAGE="https://www.dockapps.net/wmapm"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S="${WORKDIR}/${P}/${PN}"

src_prepare() {
	#Respect LDFLAGS, see bug #334747
	sed -i 's/ -o wmapm/ ${LDFLAGS} -o wmapm/' "Makefile"
	default

	pushd "${WORKDIR}"/${P} || die
	eapply "${FILESDIR}"/${P}-fno-common.patch
}

src_compile() {
	emake CC="$(tc-getCC)" COPTS="${CFLAGS}"
}

src_install() {
	dobin wmapm
	doman wmapm.1
	dodoc ../{BUGS,CHANGES,HINTS,README,TODO}
}
