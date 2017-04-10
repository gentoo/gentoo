# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHARTGRP
DIST_VERSION=2.4.10
inherit perl-module

DESCRIPTION="The Perl Chart Module"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND=">=dev-perl/GD-2.0.36"
DEPEND="${RDEPEND}
	test? (
		dev-perl/GD[png,jpeg]
	)
"
