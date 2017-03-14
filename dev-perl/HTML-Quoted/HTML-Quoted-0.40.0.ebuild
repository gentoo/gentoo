# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TSIBLEY
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Extract structure of quoted HTML mail message"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/HTML-Parser-3.0.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"
