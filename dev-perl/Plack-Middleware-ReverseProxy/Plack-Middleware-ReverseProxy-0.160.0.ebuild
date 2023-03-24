# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="MIYAGAWA"
DIST_VERSION="0.16"

inherit perl-module

DESCRIPTION="Supports app to run as a reverse proxy backend"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Plack-1.4.800"

BDEPEND="${RDEPEND}"
