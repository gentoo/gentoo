# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=RCAPUTO
MODULE_VERSION=0.921
inherit perl-module

DESCRIPTION='A non-blocking getaddrinfo() resolver'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/POE-1.311.0
	>=virtual/perl-Scalar-List-Utils-1.230.0
	>=virtual/perl-Socket-2.1.0
	>=virtual/perl-Storable-2.180.0
	>=virtual/perl-Test-Simple-0.96
	>=virtual/perl-Time-HiRes-1.971.100
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

SRC_TEST="do"
