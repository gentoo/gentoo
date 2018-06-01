# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=0.43
DIST_AUTHOR="KAWASAKI"
inherit perl-module

DESCRIPTION="Pure Perl implementation for parsing/writing XML documents"

SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

RDEPEND="
	dev-perl/libwww-perl
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PERL_RM_FILES=("t/00_pod.t")
