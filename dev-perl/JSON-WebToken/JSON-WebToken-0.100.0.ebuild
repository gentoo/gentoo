# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="XAICRON"
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="JSON Web Token (JWT) implementation"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
		>=dev-lang/perl-5.08.1
		dev-perl/JSON
		dev-perl/Module-Runtime
"
DEPEND="${RDEPEND}"
BDEPEND="
		dev-perl/Module-Build
		test? (
			>=dev-perl/Test-Mock-Guard-0.10
			>=dev-perl/Test-Requires-0.06
		)
"
