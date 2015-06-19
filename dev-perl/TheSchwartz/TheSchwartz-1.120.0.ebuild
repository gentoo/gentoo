# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/TheSchwartz/TheSchwartz-1.120.0.ebuild,v 1.1 2015/04/09 17:33:35 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=JFEARN
MODULE_VERSION=1.12
inherit perl-module

DESCRIPTION="Reliable job queue"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/Data-ObjectDriver-0.06"
DEPEND="${RDEPEND}"

SRC_TEST="do"
