# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DOMIZIO
MODULE_VERSION=1.3
inherit perl-module

DESCRIPTION="CGI::Builder and Apache/mod_perl (1 and 2) integration"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/OOTools-2.21
	>=dev-perl/CGI-Builder-1.2"
RDEPEND="${DEPEND}"
