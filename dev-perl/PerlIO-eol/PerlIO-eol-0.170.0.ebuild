# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="PerlIO layer for normalizing line endings"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND="
	virtual/perl-Exporter
	virtual/perl-XSLoader
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Test-Simple
	)
"
