# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ITUB
DIST_VERSION=0.3500
inherit perl-module

DESCRIPTION="PerlMol - Perl modules for molecular chemistry"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	virtual/perl-Storable
	virtual/perl-Test-Simple
	virtual/perl-Text-Balanced
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
