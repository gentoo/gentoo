# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GENEHACK
DIST_VERSION=0.047
inherit perl-module

DESCRIPTION="Wrap git(7) command-line interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-File-Temp
	dev-perl/File-chdir
	virtual/perl-IPC-Cmd
	virtual/perl-Scalar-List-Utils
	dev-perl/Sort-Versions
"
DEPEND="${RDEPEND}
	dev-perl/Devel-CheckBin
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	test? (
		virtual/perl-File-Path
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
