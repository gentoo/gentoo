# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.940
inherit perl-module

DESCRIPTION="Easy MIME message parsing"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Email-Address
	>=dev-perl/Email-MIME-ContentType-1.16.0
	>=dev-perl/Email-MIME-Encodings-1.314.0
	dev-perl/Email-MessageID
	>=dev-perl/Email-Simple-2.206.0
	>=virtual/perl-Encode-1.980.100
	virtual/perl-MIME-Base64
	>=dev-perl/MIME-Types-1.130.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
