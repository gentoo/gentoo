# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="RUZ"
DIST_VERSION="0.12"

inherit perl-module

DESCRIPTION="Calculate business hours in a time period"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND=">=dev-perl/Set-IntSpan-1.120.0"
DEPEND="${RDEPEND}"
