# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ARFREITAS
DIST_VERSION=0.38
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="API wrapper around the 'tar' utility"
LICENSE="GPL-3+"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# r:Cwd -> File-Spec
RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/File-Which
	dev-perl/IPC-Run
	dev-perl/Log-Log4perl
	virtual/perl-File-Path
	app-arch/tar
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-CPAN-Meta
	test? (
		>=virtual/perl-Test-Simple-1.302.73
	)
"
