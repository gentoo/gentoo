# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="NEZUMI"
MODULE_VERSION="2016.003"

inherit perl-module

DESCRIPTION="UAX #14 Unicode Line Breaking Algorithm"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="dev-perl/MIME-Charset
	virtual/perl-Encode"
DEPEND="${RDEPEND}"

SRC_TEST="do"
