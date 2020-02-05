# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=2.006002
inherit perl-module

DESCRIPTION="API for MaxMind's GeoIP2 web services and databases"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Data-Dumper
	>=dev-perl/Data-Validate-IP-0.250.0
	virtual/perl-Exporter
	virtual/perl-Getopt-Long
	dev-perl/HTTP-Message
	dev-perl/JSON-MaybeXS
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/List-SomeUtils
	virtual/perl-MIME-Base64
	>=dev-perl/MaxMind-DB-Reader-1.0.0
	dev-perl/Moo
	dev-perl/Params-Validate
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Quote
	dev-perl/Throwable
	dev-perl/Try-Tiny
	dev-perl/URI
	dev-perl/namespace-clean
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO-Compress
		dev-perl/MaxMind-DB-Common
		dev-perl/Path-Class
		dev-perl/Test-Fatal
		dev-perl/Test-Number-Delta
		>=virtual/perl-Test-Simple-0.960.0
	)
"
