# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Accessor-Chained/Class-Accessor-Chained-0.10.0-r1.ebuild,v 1.2 2015/06/13 21:34:26 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Perl module to make chained class accessors"

SLOT="0"
KEYWORDS="amd64 x86 ~ppc-aix ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Class-Accessor"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST="do"
