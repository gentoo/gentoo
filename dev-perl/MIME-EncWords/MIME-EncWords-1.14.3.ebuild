# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=NEZUMI
DIST_VERSION=1.014.3
inherit perl-module

DESCRIPTION="Deal with RFC 2047 encoded words (improved)"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
PERL_RM_FILES=("t/pod.t")
RDEPEND="
	>=virtual/perl-MIME-Base64-2.130.0
	>=virtual/perl-Encode-1.980.0
	>=dev-perl/MIME-Charset-1.10.1
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
