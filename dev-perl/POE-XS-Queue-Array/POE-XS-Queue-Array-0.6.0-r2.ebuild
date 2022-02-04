# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TONYC
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="An XS implementation of POE::Queue::Array"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/POE
"
BDEPEND="${RDEPEND}
"
