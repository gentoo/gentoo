# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSCHILLI
DIST_VERSION=0.23
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="API wrapper around the 'tar' utility"

SLOT="0"
KEYWORDS="~amd64 ~x86"
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
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
