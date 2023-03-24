# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="EHUELS"

inherit perl-module

DESCRIPTION="Moo/Moose mappers for minimalist PGObject framework"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/PGObject-Simple-3.0.2
	dev-perl/Moo"

BDEPEND="${RDEPEND}"
