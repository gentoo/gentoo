# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RUBYKAT
MODULE_VERSION=2.5201

inherit perl-module

DESCRIPTION="Convert a plain text file to HTML"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	!dev-perl/TextToHTML
	virtual/perl-Getopt-Long
	dev-perl/YAML-Syck
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

SRC_TEST="do"
