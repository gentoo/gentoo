# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pigz/pigz-2.3.3.ebuild,v 1.2 2015/05/20 01:55:37 mattst88 Exp $

EAPI=5

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="A parallel implementation of gzip"
HOMEPAGE="http://www.zlib.net/pigz/"
SRC_URI="http://www.zlib.net/pigz/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~sparc ~x86 ~amd64-linux ~sparc64-solaris"
IUSE="static symlink test"

LIB_DEPEND="sys-libs/zlib[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	test? ( app-arch/ncompress )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	use static && append-ldflags -static
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
	dosym ${PN} /usr/bin/un${PN}
	dodoc README
	doman ${PN}.1

	if use symlink; then
		dosym ${PN} /usr/bin/gzip
		dosym un${PN} /usr/bin/gunzip
	fi
}
