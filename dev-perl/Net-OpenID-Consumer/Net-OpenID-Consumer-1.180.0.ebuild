# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=WROG
DIST_VERSION=1.18
inherit perl-module

DESCRIPTION="Library for consumers of OpenID identities"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Digest-SHA
	dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/libwww-perl
	virtual/perl-MIME-Base64
	>=dev-perl/Net-OpenID-Common-1.190.0
	virtual/perl-Storable
	virtual/perl-Time-Local
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/CGI
		virtual/perl-Test-Simple
	)
"
