# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LICHTKIND
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="The Perl Chart Module"

# Bundles lots of things in jquery.js (bug #724570)
LICENSE="|| ( Artistic GPL-1+ ) || ( MIT ( GPL-1 GPL-2 ) )"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-perl/GD-2.0.36
	dev-perl/Graphics-Toolkit-Color
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/GD[png(+),jpeg(+)]
		dev-perl/Test-Warn
	)
"
