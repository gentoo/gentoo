# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/TheSchwartz/TheSchwartz-1.100.0-r1.ebuild,v 1.1 2014/08/24 01:19:16 axs Exp $

EAPI=5

MODULE_AUTHOR=SIXAPART
MODULE_VERSION=1.10
inherit perl-module

DESCRIPTION="Reliable job queue"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-perl/Data-ObjectDriver-0.06"
DEPEND="${RDEPEND}"

SRC_TEST="do"
