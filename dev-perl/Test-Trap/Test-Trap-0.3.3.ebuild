# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EBHANSSEN
DIST_VERSION=v${PV}

inherit perl-module

DESCRIPTION="Trap exit codes, exceptions, output, etc"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-Dump
	virtual/perl-Exporter
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-version
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.3
	test? (
		>=virtual/perl-Test-Simple-1.1.10
	)"
