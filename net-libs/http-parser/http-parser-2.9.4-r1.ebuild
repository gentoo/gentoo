# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs multilib-minimal

DESCRIPTION="HTTP request/response parser for C"
HOMEPAGE="https://github.com/nodejs/http-parser"
SRC_URI="https://github.com/nodejs/http-parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
# 2.9.4 restored ABI compatibility with 2.9.0 but since we failed
# to set subslot in 2.9.3, we want to provoke another rebuild
SLOT="0/2.9.4"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sparc x86 ~amd64-linux ~x64-macos ~x64-solaris"

PATCHES=(
	"${FILESDIR}"/${P}-non-x86-test.patch
)

src_prepare() {
	default
	tc-export CC AR
	multilib_copy_sources
}

multilib_src_compile() {
	emake PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" CFLAGS_FAST="${CFLAGS}" library
}

multilib_src_test() {
	emake CFLAGS_DEBUG="${CFLAGS}" CFLAGS_FAST="${CFLAGS}" test
}

multilib_src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
}
