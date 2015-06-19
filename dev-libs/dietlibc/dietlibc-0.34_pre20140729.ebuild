# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dietlibc/dietlibc-0.34_pre20140729.ebuild,v 1.3 2015/02/28 22:44:59 zorry Exp $

EAPI=5
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A libc optimized for small size"
HOMEPAGE="http://www.fefe.de/dietlibc/"
SRC_URI="http://dev.gentoo.org/~patrick/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=" ~alpha ~amd64 ~arm ~ia64 ~mips ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

DIETHOME=/usr/diet

S=${WORKDIR}/dietlibc

src_prepare() {
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
	gcc-specs-pie && append-flags -nopie

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
