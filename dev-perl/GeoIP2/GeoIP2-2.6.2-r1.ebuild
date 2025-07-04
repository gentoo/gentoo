# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MAXMIND
DIST_VERSION=2.006002
inherit perl-module

DESCRIPTION="API for MaxMind's GeoIP2 web services and databases"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv x86"

RDEPEND="
	>=dev-perl/Data-Validate-IP-0.250.0
	dev-perl/HTTP-Message
	dev-perl/JSON-MaybeXS
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/List-SomeUtils
	>=dev-perl/MaxMind-DB-Reader-1.0.0
	dev-perl/Moo
	dev-perl/Params-Validate
	dev-perl/Sub-Quote
	dev-perl/Throwable
	dev-perl/Try-Tiny
	dev-perl/URI
	dev-perl/namespace-clean
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/MaxMind-DB-Common
		dev-perl/Path-Class
		dev-perl/Test-Fatal
		dev-perl/Test-Number-Delta
		>=virtual/perl-Test-Simple-0.960.0
	)
"
