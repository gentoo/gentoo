# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="File signing and signature verification utility"
HOMEPAGE="http://swapped.cc/sign/"
SRC_URI="http://swapped.cc/${PN}/files/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-openssl-0.9.8.patch
	epatch "${FILESDIR}"/${PV}-as-needed.patch
	# remove -g from CFLAGS, it happens to break the build on ppc-macos
	sed -i -e 's/-g//' src/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman man/${PN}.1
	dodoc README
	dosym ${PN} /usr/bin/un${PN}
}
