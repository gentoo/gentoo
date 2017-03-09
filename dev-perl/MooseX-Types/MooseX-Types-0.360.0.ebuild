# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.36
inherit perl-module

DESCRIPTION="Organise your Moose types in libraries"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="test"

RDEPEND=">=dev-perl/Moose-1.06
	dev-perl/Sub-Name
	>=dev-perl/Carp-Clan-6.00
	>=dev-perl/Sub-Install-0.924
	>=dev-perl/namespace-clean-0.190.0"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
		dev-perl/Test-CheckDeps
	)"

SRC_TEST=do
