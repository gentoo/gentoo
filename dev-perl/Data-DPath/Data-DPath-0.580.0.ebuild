# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="SCHWIGON"
DIST_VERSION="0.58"

inherit perl-module

DESCRIPTION="DPath is not XPath!"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Iterator-Util
	dev-perl/Sub-Exporter
	>=dev-perl/aliased-0.340.0
	dev-perl/Class-XSAccessor"

BDEPEND="${RDEPEND}
	test? ( dev-perl/Test-Deep )"
