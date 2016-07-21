# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=VIY
MODULE_VERSION=0.9510
inherit perl-module

DESCRIPTION='Perl/XS module to use HTML Templates from CGI scripts'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-File-Path-2.0.0
	virtual/perl-File-Spec
	>=dev-perl/JSON-2.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-libs/libpcre
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
