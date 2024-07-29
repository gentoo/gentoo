# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DLAMBLEY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl extension to use the zero copy IO syscalls"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	test? (
		virtual/perl-IO
		dev-perl/File-Slurp
		virtual/perl-File-Temp
	)
"
