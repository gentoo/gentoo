# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Factory-Util/Class-Factory-Util-1.700.0-r1.ebuild,v 1.3 2015/06/13 21:37:53 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=1.7
inherit perl-module

DESCRIPTION="Provide utility methods for factory classes"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ppc ~ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28"
