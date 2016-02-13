# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=JHI
DIST_VERSION=0.9704
inherit perl-module

DESCRIPTION="Data structure and ops for directed graphs"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Storable-2.05
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
