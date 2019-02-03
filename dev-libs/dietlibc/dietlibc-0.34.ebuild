# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit flag-o-matic toolchain-funcs

DESCRIPTION="A libc optimized for small size"
HOMEPAGE="https://www.fefe.de/dietlibc/"
SRC_URI="https://www.fefe.de/dietlibc/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

DIETHOME="/usr/diet"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if $(tc-getLD) --version | grep -q "2.31.1"; then
			ewarn "${PN} does not work with unpatched binutils-2.31.1,"
			ewarn "see \"${S}/FAQ\""
			ewarn "and https://bugs.gentoo.org/672126 for details."
			ewarn "In the meanwhile you can install another binutils version"
			ewarn "and use binutils-config to switch version."
			sleep 10
		fi
	fi
}

src_prepare() {
	default

	# Replace sparc64 related C[XX]FLAGS (see bug #45716)
	use sparc && replace-sparc64-flags

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
