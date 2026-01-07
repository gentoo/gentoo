# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RURBAN
DIST_VERSION=4.40
DIST_EXAMPLES=("eg/*")
DIST_WIKI="tests"
inherit perl-module

DESCRIPTION="cPanel fork of JSON::XS, fast and correct serializing"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Math-BigInt-1.160.0
	>=virtual/perl-Encode-1.980.100
	>=virtual/perl-podlators-2.80.0
"

pkg_postinst() {
	ewarn "This package provides 'cpanel_json_xs' in PATH, which includes optional features"
	ewarn "otherwise not automatically made available yet. If you desire to use these,"
	ewarn "please consult:"
	ewarn " https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}#Optional_Features"
}
