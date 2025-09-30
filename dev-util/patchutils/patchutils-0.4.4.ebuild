# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Collection of tools that operate on patch files"
HOMEPAGE="https://cyberelk.net/tim/software/patchutils/"
SRC_URI="https://github.com/twaugh/patchutils/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="pcre"

RDEPEND="pcre? ( dev-libs/libpcre2:= )"
DEPEND="
	${RDEPEND}
	elibc_musl? ( >=sys-libs/error-standalone-2.0 )
"
BDEPEND="virtual/pkgconfig"
RDEPEND+="
	!<app-shells/bash-completion-2.16.0-r3
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG

	if use elibc_musl; then
		export CFLAGS="${CFLAGS} $(${PKG_CONFIG} --cflags error-standalone)"
		export LIBS="${LIBS} $(${PKG_CONFIG} --libs error-standalone)"
	fi

	econf $(use_with pcre pcre2)
}
