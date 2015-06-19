# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MLDBM/MLDBM-2.40.0-r1.ebuild,v 1.2 2015/06/13 22:13:21 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=2.04
inherit perl-module

DESCRIPTION="A multidimensional/tied hash Perl Module"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
