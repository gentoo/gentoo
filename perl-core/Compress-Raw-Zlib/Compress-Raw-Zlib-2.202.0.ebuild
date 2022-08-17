# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PMQS
DIST_TEST=parallel
DIST_VERSION=2.202
inherit perl-module

DESCRIPTION="Low-Level Interface to zlib compression library"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# We use the bundled version of zlib as the minimum version for the system copy
# Check on bumps! Look in https://github.com/pmqs/Compress-Raw-Zlib/commits/master/zlib-src.
RDEPEND=">=sys-libs/zlib-1.2.12"
DEPEND="${RDEPEND}"
BDEPEND="virtual/perl-ExtUtils-MakeMaker"

src_prepare() {
	rm -rf "${S}"/zlib-src/ || die
	sed -i '/^zlib-src/d' "${S}"/MANIFEST || die
	perl-module_src_prepare
}

src_configure() {
	BUILD_ZLIB=False ZLIB_INCLUDE="${ESYSROOT}"/usr/include \
		ZLIB_LIB="${ESYSROOT}"/usr/$(get_libdir) perl-module_src_configure
}
