# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SRI
DIST_VERSION=7.11
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Real-time web framework"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

RDEPEND="
	!minimal? (
		>=dev-perl/EV-4.0.0
	)
	>=virtual/perl-IO-Socket-IP-0.370.0
	>=virtual/perl-JSON-PP-2.271.30
	>=virtual/perl-Pod-Simple-3.90.0
	>=virtual/perl-Time-Local-1.200.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/pod{,_coverage}.t
	perl-module_src_test
}
