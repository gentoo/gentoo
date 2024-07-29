# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BFAIST
inherit perl-module

DESCRIPTION="Web service API to MusicBrainz database"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"

RDEPEND="
	>=dev-perl/Mojolicious-7.130.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"

PATCHES=( "${FILESDIR}/1.0.2-no-network-testing.patch" )
