# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.952
inherit perl-module

DESCRIPTION="Easy MIME message parsing"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86 ~sparc-solaris ~x86-solaris"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Email-Address-XS
	>=dev-perl/Email-MIME-ContentType-1.23.0
	>=dev-perl/Email-MIME-Encodings-1.314.0
	dev-perl/Email-MessageID
	>=dev-perl/Email-Simple-2.212.0
	>=virtual/perl-Encode-1.980.100
	virtual/perl-MIME-Base64
	>=dev-perl/MIME-Types-1.130.0
	dev-perl/Module-Runtime
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
