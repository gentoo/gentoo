# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=3.001
inherit perl-module

DESCRIPTION="Mail::Box connector via IMAP4"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/TimeDate
	dev-perl/Digest-HMAC
	virtual/perl-Digest-MD5
	virtual/perl-File-Spec
	>=dev-perl/Mail-Box-3
	dev-perl/Mail-IMAPClient
	>=dev-perl/Mail-Message-3
	>=dev-perl/Mail-Transport-3
	virtual/perl-Scalar-List-Utils
	!!<dev-perl/Mail-Box-3
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
