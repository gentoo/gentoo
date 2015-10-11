# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic eutils

DESCRIPTION="Parallel bzip2 (de)compressor using libbz2"
HOMEPAGE="http://compression.ca/pbzip2/ https://launchpad.net/pbzip2"
SRC_URI="https://launchpad.net/pbzip2/${PV:0:3}/${PV}/+download/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static symlink"

LIB_DEPEND="app-arch/bzip2[static-libs(+)]"
RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	symlink? ( !app-arch/lbzip2[symlink] )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.10-makefile.patch
	tc-export CXX
	use static && append-ldflags -static
}

src_install() {
	dobin pbzip2
	dodoc AUTHORS ChangeLog README
	doman pbzip2.1
	dosym pbzip2 /usr/bin/pbunzip2

	if use symlink ; then
		local s
		for s in bzip2 bunzip2 bzcat ; do
			dosym pbzip2 /usr/bin/${s}
		done
	fi
}
