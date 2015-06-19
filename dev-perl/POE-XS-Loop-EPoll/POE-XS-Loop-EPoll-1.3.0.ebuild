# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-XS-Loop-EPoll/POE-XS-Loop-EPoll-1.3.0.ebuild,v 1.1 2013/09/15 13:43:36 zlogene Exp $

EAPI=5

MODULE_AUTHOR=TONYC
MODULE_VERSION=1.003
inherit perl-module

DESCRIPTION="An XS implementation of POE::Loop, using Linux epoll(2)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/POE-1.287
	>=dev-perl/POE-Test-Loops-1.033"
RDEPEND="${DEPEND}"

SRC_TEST="do"
