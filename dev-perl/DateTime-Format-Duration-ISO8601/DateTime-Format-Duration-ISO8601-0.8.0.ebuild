# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PERLANCAR"
DIST_VERSION="0.008"

inherit perl-module

DESCRIPTION="Parse and format ISO8601 duration"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/DateTime"

BDEPEND="${RDEPEND}"
