# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CHARTGRP
DIST_VERSION=2.4.10
inherit perl-module

DESCRIPTION="The Perl Chart Module"
# bundles lots of things in jquery.js
# https://bugs.gentoo.org/724570
LICENSE="|| ( Artistic GPL-1+ ) || ( MIT ( GPL-1 GPL-2 ) )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/GD-2.0.36"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/GD[png(+),jpeg(+)]
	)
"
