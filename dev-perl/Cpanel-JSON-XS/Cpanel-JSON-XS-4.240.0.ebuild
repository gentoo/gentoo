# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RURBAN
DIST_VERSION=4.24
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="cPanel fork of JSON::XS, fast and correct serializing"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Math-BigInt-1.160.0
	virtual/perl-Carp
	>=virtual/perl-Encode-1.980.100
	virtual/perl-Exporter
	virtual/perl-XSLoader
	>=virtual/perl-podlators-2.80.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Test
		virtual/perl-Test-Simple
		virtual/perl-Time-Piece
	)
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
src_test() {
	ewarn "Comprehensive testing may require manual installation of dependencies"
	ewarn " See: https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}#Tests"
	perl-module_src_test
}
pkg_postinst() {
	ewarn "This package provides 'cpanel_json_xs' in PATH, which includes optional features"
	ewarn "otherwise not automatically made available yet. If you desire to use these,"
	ewarn "please consult:"
	ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}#Optional_Features"
}
