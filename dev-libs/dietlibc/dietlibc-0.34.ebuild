# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A libc optimized for small size"
HOMEPAGE="https://www.fefe.de/dietlibc/"
SRC_URI="https://www.fefe.de/dietlibc/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=sys-devel/binutils-2.31.1-r4"
RDEPEND=""

DIETHOME="/usr/diet"

src_prepare() {
	default

	# bug #855677
	filter-lto

	# Replace sparc64 related C[XX]FLAGS (see bug #45716)
	use sparc && replace-sparc64-flags

	# bug 676704
	use sparc && tc-is-gcc && append-flags -fno-tree-pre

	# gcc-hppa suffers support for SSP, compilation will fail
	use hppa && strip-unsupported-flags

	# Makefile does not append CFLAGS
	append-flags -W -Wall -Wchar-subscripts \
		-Wmissing-prototypes -Wmissing-declarations -Wno-switch \
		-Wno-unused -Wredundant-decls -fno-strict-aliasing

	# Disable ssp for we default to it on >=gcc-4.8.3
	append-flags $(test-flags -fno-stack-protector)

	# only use -nopie on archs that support it
	tc-enables-pie && append-flags -no-pie

	sed -i -e 's:strip::' Makefile || die
	append-flags -Wa,--noexecstack
}

src_compile() {
	emake prefix="${EPREFIX}"${DIETHOME} \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		STRIP=":"
}

src_install() {
	emake -j1 prefix="${EPREFIX}"${DIETHOME} \
		DESTDIR="${D}" \
		install-bin \
		install-headers \
		install-profiling

	dobin "${ED}"${DIETHOME}/bin/*
	doman "${ED}"${DIETHOME}/man/*/*
	rm -r "${ED}"${DIETHOME}/{man,bin} || die

	dodoc AUTHOR BUGS CAVEAT CHANGES README THANKS TODO PORTING
}
