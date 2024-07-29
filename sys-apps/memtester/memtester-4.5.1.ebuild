# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Userspace utility for testing the memory subsystem for faults"
HOMEPAGE="http://pyropus.ca/software/memtester/"
SRC_URI="
	https://pyropus.ca./software/memtester/${P}.tar.gz
	https://pyropus.ca./software/memtester/old-versions/${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

src_configure() {
	echo "$(tc-getCC) ${CFLAGS} ${CPPFLAGS} -DPOSIX -c" > conf-cc || die
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS}" > conf-ld || die
}

src_install() {
	dosbin memtester
	doman memtester.8
	dodoc BUGS CHANGELOG README README.tests
}
