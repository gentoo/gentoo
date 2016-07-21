# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=NI-S
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Utility for looking for perl objects that are not reclaimed"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~x86"

DEPEND="virtual/perl-ExtUtils-MakeMaker"
