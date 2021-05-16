# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="A libc optimized for small size"
HOMEPAGE="http://www.fefe.de/dietlibc/"
SRC_URI="https://dev.gentoo.org/~patrick/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

DIETHOME="/usr/diet"

S="${WORKDIR}/dietlibc"

src_prepare() {
	default

	# use __DYN_LIB instead of __PIC__ in i386 socketcalls, bug #644116
	eapply "${FILESDIR}"/${P}-dyn-lib.patch

	# Replace sparc64 related C[XX]FLAGS (see bug #45716)
	use sparc && replace-sparc64-flags

	# gcc-hppa suffers support for SSP, compilation will fail
	use hppa && strip-unsupported-flags

	# Makefile does not append CFLAGS
	append-flags -nostdinc -W -Wall -Wextra -Wchar-subscripts \
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
	emake -j1 prefix="${EPREFIX}"${DIETHOME} \
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
