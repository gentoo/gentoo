# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Time and memory-efficiency tests of various C/POSIX standard library functions"
HOMEPAGE="http://www.etalabs.net/libc-bench.html http://git.musl-libc.org/cgit/libc-bench/"
SRC_URI="http://www.etalabs.net/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/respect-flags.patch
)

src_configure() {
	tc-export CC

	append-cflags "${CPPFLAGS}"
}

src_install() {
	dobin libc-bench
}
