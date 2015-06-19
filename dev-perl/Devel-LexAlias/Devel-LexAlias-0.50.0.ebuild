# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-LexAlias/Devel-LexAlias-0.50.0.ebuild,v 1.1 2013/09/06 19:27:32 zlogene Exp $

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Alias lexical variables"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DEPEND=">=dev-perl/Devel-Caller-2.03"
RDEPEND="${DEPEND}"

SRC_TEST="do"
