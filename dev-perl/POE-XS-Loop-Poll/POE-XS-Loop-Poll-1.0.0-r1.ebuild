# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-XS-Loop-Poll/POE-XS-Loop-Poll-1.0.0-r1.ebuild,v 1.1 2014/08/26 19:20:48 axs Exp $

EAPI=5

MODULE_AUTHOR=TONYC
MODULE_VERSION=1.000
inherit perl-module

DESCRIPTION="An XS implementation of POE::Loop, using poll(2)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/POE-1.287
	>=dev-perl/POE-Test-Loops-1.033"
RDEPEND="${DEPEND}"

SRC_TEST="do"
