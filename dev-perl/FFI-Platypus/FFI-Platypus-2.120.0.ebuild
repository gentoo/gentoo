# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=2.12
inherit flag-o-matic perl-module

DESCRIPTION="Write Perl bindings to non-Perl libraries with FFI, no XS required"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libffi:=
	dev-perl/Capture-Tiny
	>=dev-perl/FFI-CheckLib-0.50.0
	virtual/pkgconfig
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-ParseXS-3.300.0
"

src_configure() {
	# Mismatch w/ stubs
	filter-lto
	# Needed because of Perl's CFLAGS saving
	append-flags $(test-flags-CC -fno-lto)

	perl-module_src_configure
}
