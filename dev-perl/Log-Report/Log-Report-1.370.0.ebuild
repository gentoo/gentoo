# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=1.37
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Pluggable, multilingual handler driven problem reporting system"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Devel-GlobalDestruction-0.90.0
	>=virtual/perl-Encode-2.0.0
	>=dev-perl/Log-Report-Optional-1.70.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/String-Print-0.910.0
	>=virtual/perl-Sys-Syslog-0.270.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.860.0
	)
"
