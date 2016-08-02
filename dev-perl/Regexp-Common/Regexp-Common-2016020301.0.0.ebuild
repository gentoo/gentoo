# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ABIGAIL
DIST_VERSION=2016020301
inherit perl-module

DESCRIPTION="Provide commonly requested regular expressions"

LICENSE="|| ( Artistic Artistic-2 MIT BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
