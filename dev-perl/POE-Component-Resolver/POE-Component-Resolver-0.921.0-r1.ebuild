# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCAPUTO
DIST_VERSION=0.921
inherit perl-module

DESCRIPTION='A non-blocking getaddrinfo() resolver'
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/POE-1.311.0
	>=virtual/perl-Scalar-List-Utils-1.230.0
	>=virtual/perl-Socket-2.1.0
	>=virtual/perl-Storable-2.180.0
	>=virtual/perl-Test-Simple-0.96
	>=virtual/perl-Time-HiRes-1.971.100
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"
