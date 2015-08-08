# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils flag-o-matic toolchain-funcs

GITHUB_AUTHOR="hollow"
GITHUB_PROJECT="dietlibc"
GITHUB_COMMIT="4e86d5e"

DESCRIPTION="A libc optimized for small size"
HOMEPAGE="http://www.fefe.de/dietlibc/"
SRC_URI="http://nodeload.github.com/${GITHUB_AUTHOR}/${GITHUB_PROJECT}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ia64 ~mips sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${GITHUB_AUTHOR}-${GITHUB_PROJECT}-${GITHUB_COMMIT}

DIETHOME=/usr/diet

pkg_setup() {
	# Replace sparc64 related C[XX]FLAGS (see bug #45716)
	use sparc && replace-sparc64-flags

	# gcc-hppa suffers support for SSP, compilation will fail
	use hppa && strip-unsupported-flags

	# debug flags
	use debug && append-flags -g

	# Makefile does not append CFLAGS
	append-flags -nostdinc -W -Wall -Wextra -Wchar-subscripts \
		-Wmissing-prototypes -Wmissing-declarations -Wno-switch \
		-Wno-unused -Wredundant-decls -fno-strict-aliasing

	# only use -nopie on archs that support it
	gcc-specs-pie && append-flags -nopie
}

src_compile() {
	emake prefix="${EPREFIX}"${DIETHOME} \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		STRIP=":" \
		|| die "make failed"
}

src_install() {
	emake prefix="${EPREFIX}"${DIETHOME} \
		DESTDIR="${D}" \
		install-bin \
		install-headers \
		|| die "make install failed"

	dobin "${ED}"${DIETHOME}/bin/* || die "dobin failed"
	doman "${ED}"${DIETHOME}/man/*/* || die "doman failed"
	rm -r "${ED}"${DIETHOME}/{man,bin}

	dodoc AUTHOR BUGS CAVEAT CHANGES README THANKS TODO PORTING
}
