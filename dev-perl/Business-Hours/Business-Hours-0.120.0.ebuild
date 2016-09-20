# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="RUZ"
MODULE_VERSION="0.12"

inherit perl-module

DESCRIPTION="Calculate business hours in a time period"

LICENSE="Artistic GPL-1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Set-IntSpan-1.120.0"
DEPEND="${RDEPEND}"

SRC_TEST="do"
