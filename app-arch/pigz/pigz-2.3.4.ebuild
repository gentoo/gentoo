# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A parallel implementation of gzip"
HOMEPAGE="http://www.zlib.net/pigz/"
SRC_URI="http://www.zlib.net/pigz/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~sparc ~x86 ~amd64-linux ~ppc-macos ~sparc64-solaris"
IUSE="static symlink test"

LIB_DEPEND="sys-libs/zlib[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	test? ( app-arch/ncompress )"

src_compile() {
	use static && append-ldflags -static
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
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
