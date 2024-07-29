# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANWAR
DIST_VERSION=1.281
inherit perl-module

DESCRIPTION="A Simple totally OO CGI interface that is CGI.pm compliant"

# Bug: https://bugs.gentoo.org/721422
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

BDEPEND="
	dev-perl/Module-Build
	test? (
		dev-perl/libwww-perl
		dev-perl/IO-stringy
		virtual/perl-File-Temp
		dev-perl/Test-Exception
		dev-perl/Test-NoWarnings
	)
"
