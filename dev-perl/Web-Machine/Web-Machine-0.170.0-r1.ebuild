# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="A Perl port of Webmachine"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/HTTP-Headers-ActionPack
	dev-perl/Hash-MultiValue
	dev-perl/IO-Handle-Util
	dev-perl/Module-Runtime
	dev-perl/Sub-Exporter
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Net-HTTP
		dev-perl/Path-Class
		dev-perl/Plack[minimal]
		dev-perl/Test-FailWarnings
		dev-perl/Test-Fatal
	)
"
