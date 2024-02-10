# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edo flag-o-matic toolchain-funcs

DESCRIPTION="bsdiff: Binary Differencer using a suffix alg"
HOMEPAGE="https://www.daemonology.net/bsdiff/"
SRC_URI="https://www.daemonology.net/bsdiff/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="app-arch/bzip2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-CVE-2014-9862.patch"
)

src_compile() {
	append-lfs-flags

	edo $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -o bsdiff bsdiff.c -lbz2
	edo $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -o bspatch bspatch.c -lbz2
}

src_install() {
	dobin bs{diff,patch}
	doman bs{diff,patch}.1
}
