# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ALEXMV
DIST_VERSION=2.09
inherit perl-module

DESCRIPTION="Extract the structure of a quoted mail message"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-perl/Text-Autoformat
	virtual/perl-Text-Tabs+Wrap
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"
