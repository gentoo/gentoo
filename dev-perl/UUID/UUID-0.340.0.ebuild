# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JRM
DIST_VERSION=0.34
inherit perl-module

DESCRIPTION="Perl extension for using UUID interfaces as defined in e2fsprogs"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/Devel-CheckLib-1.140.0
"
DEPEND="${RDEPEND}"
