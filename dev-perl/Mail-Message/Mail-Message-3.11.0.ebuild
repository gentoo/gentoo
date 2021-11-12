# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=3.011
inherit perl-module

DESCRIPTION="General Message Object for MIME Messsage Handling"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-perl/TimeDate
	>=virtual/perl-Encode-2.260.0
	>=virtual/perl-File-Spec-0.700.0
	dev-perl/IO-stringy
	virtual/perl-MIME-Base64
	>=dev-perl/MIME-Types-1.4.0
	>=dev-perl/MailTools-2.170.0
	>=virtual/perl-Scalar-List-Utils-1.130.0
	>=dev-perl/URI-1.230.0
	>=dev-perl/User-Identity-1.0.0
	!!<dev-perl/Mail-Box-3
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
