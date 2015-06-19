# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Stag/Data-Stag-0.130.0-r1.ebuild,v 1.1 2014/08/22 20:54:02 axs Exp $

EAPI=5

MODULE_AUTHOR=CMUNGALL
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Structured Tags datastructures"
HOMEPAGE="http://stag.sourceforge.net/ ${HOMEPAGE}"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/IO-String"
DEPEND="${RDEPEND}"

SRC_TEST="do"
