# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_A_EXT=tgz
DIST_AUTHOR=JPIERCE
DIST_VERSION=0.39
inherit perl-module

DESCRIPTION="Select a pager, optionally pipe it output if destination is a TTY"

SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-File-Spec
	dev-perl/File-Which
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-Test-Simple
		virtual/perl-File-Temp
	)
"
PATCHES=( "${FILESDIR}/${P}-no-dot-inc.patch" )
