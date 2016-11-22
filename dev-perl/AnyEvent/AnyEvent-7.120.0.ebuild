# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=7.12
inherit perl-module

DESCRIPTION="Provides a uniform interface to various event loops"

SLOT="0"
KEYWORDS="alpha amd64 arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	dev-perl/Canary-Stability
"
