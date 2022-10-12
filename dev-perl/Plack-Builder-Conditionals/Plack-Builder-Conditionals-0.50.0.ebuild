# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="KAZEBURO"
DIST_VERSION="0.05"

inherit perl-module

DESCRIPTION="Plack::Builder match-based rules"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Plack-1.4.800
	dev-perl/List-MoreUtils
	dev-perl/Net-CIDR-Lite"

BDEPEND="${RDEPEND}
	dev-perl/Module-Build"
