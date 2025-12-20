# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit autotools python-single-r1 toolchain-funcs

DESCRIPTION="Collection of tools that operate on patch files"
HOMEPAGE="https://cyberelk.net/tim/software/patchutils/"
SRC_URI="https://github.com/twaugh/patchutils/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="pcre"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	!<app-shells/bash-completion-2.16.0-r3
	pcre? ( dev-libs/libpcre2:= )
	${PYTHON_DEPS}
"
DEPEND="
	${RDEPEND}
	elibc_musl? ( >=sys-libs/error-standalone-2.0 )
"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
	python_fix_shebang patchview
}

src_configure() {
	tc-export PKG_CONFIG

	if use elibc_musl; then
		export CFLAGS="${CFLAGS} $(${PKG_CONFIG} --cflags error-standalone)"
		export LIBS="${LIBS} $(${PKG_CONFIG} --libs error-standalone)"
	fi

	econf $(use_with pcre pcre2)
}
