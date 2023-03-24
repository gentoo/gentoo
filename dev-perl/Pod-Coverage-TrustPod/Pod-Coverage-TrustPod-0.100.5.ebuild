# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="RJBS"
DIST_VERSION="0.100005"

inherit perl-module

DESCRIPTION="Allow a module's pod to contain Pod::Coverage hints"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Pod-Coverage
	dev-perl/Pod-Eventual
	dev-perl/Pod-Parser"

BDEPEND="${RDEPEND}"
