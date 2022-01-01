# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FERREIRA
DIST_VERSION=0.73
inherit perl-module

DESCRIPTION="Run shell commands transparently within perl"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=( t/99_pod.t )
