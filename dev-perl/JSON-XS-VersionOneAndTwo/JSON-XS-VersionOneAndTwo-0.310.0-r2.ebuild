# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LBROCARD
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="Support versions 1 and 2 of JSON::XS"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"

RDEPEND="dev-perl/JSON-XS"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)
"
