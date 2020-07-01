# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=3.002
inherit perl-module

DESCRIPTION="General Message Object for MIME Messsage Handling"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

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
	>=dev-perl/User-Identity-0.940.0
	!!<dev-perl/Mail-Box-3
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
