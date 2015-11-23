# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=txt2html
MODULE_AUTHOR=RUBYKAT
MODULE_VERSION=2.5201
inherit perl-module

DESCRIPTION="HTML::TextToHTML - convert plain text file to HTML"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!dev-perl/txt2html
	dev-perl/YAML-Syck
	virtual/perl-Getopt-Long
	dev-perl/Getopt-ArgvFile
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST="do"
