# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REHSACK
DIST_VERSION=1.006
inherit perl-module

DESCRIPTION="Get home directory for self or other user"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="+xdg"

RDEPEND="
	>=virtual/perl-File-Path-2.10.0
	>=virtual/perl-File-Spec-3.120.0
	>=virtual/perl-File-Temp-0.190.0
	>=dev-perl/File-Which-0.50.0
	xdg? ( x11-misc/xdg-user-dirs )
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.900.0
	)
"
