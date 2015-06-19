# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-CGI-Builder/Apache-CGI-Builder-1.300.0-r1.ebuild,v 1.1 2014/08/26 18:48:02 axs Exp $

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
