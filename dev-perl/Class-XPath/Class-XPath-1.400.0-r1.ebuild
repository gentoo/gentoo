# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-XPath/Class-XPath-1.400.0-r1.ebuild,v 1.1 2014/08/22 17:23:44 axs Exp $

EAPI=5

MODULE_AUTHOR=SAMTREGAR
MODULE_VERSION=1.4
inherit perl-module

DESCRIPTION="adds xpath matching to object trees"

SLOT="0"
KEYWORDS="amd64 ia64 sparc x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/HTML-Tree )"

SRC_TEST="do"
