# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHANSEN
DIST_VERSION=0.5
inherit perl-module

DESCRIPTION="Simple Authentication"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Class-Accessor
	dev-perl/Class-Data-Inheritable
	dev-perl/Crypt-PasswdMD5
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	virtual/perl-MIME-Base64
	dev-perl/Params-Validate
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? ( virtual/perl-Test-Simple )
"
