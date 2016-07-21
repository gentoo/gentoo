# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=BINGOS
MODULE_VERSION=1.38
inherit perl-module

DESCRIPTION="Patch perl source a la Devel::PPPort's buildperl.pl"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-perl/File-pushd-1.0.0
	virtual/perl-IO
	virtual/perl-MIME-Base64
	dev-perl/Module-Pluggable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do parallel"
