# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_A_EXT=tgz
DIST_AUTHOR=JPIERCE
DIST_VERSION=2.10
inherit perl-module

DESCRIPTION="Select a pager, optionally pipe it output if destination is a TTY"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND="
	virtual/perl-File-Spec
	dev-perl/File-Which
	virtual/perl-IO
	dev-perl/TermReadKey
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-File-Temp
	)
"
