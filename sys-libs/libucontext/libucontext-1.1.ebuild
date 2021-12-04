# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ucontext implementation featuring glibc-compatible ABI"
HOMEPAGE="https://github.com/kaniini/libucontext"
SRC_URI="https://github.com/kaniini/libucontext/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+man"

BDEPEND="man? ( app-text/scdoc )"

# segfault needs investigation
RESTRICT="test"

src_compile() {
	tc-export AR CC

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" check
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install

	if use man ; then
		emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install_docs
	fi
}
