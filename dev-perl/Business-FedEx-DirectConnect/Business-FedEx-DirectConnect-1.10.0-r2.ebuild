# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JPOWERS
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Interface to FedEx Ship Manager Direct"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"

RDEPEND="dev-perl/libwww-perl
	dev-perl/Tie-StrictHash"
BDEPEND="${RDEPEND}"
