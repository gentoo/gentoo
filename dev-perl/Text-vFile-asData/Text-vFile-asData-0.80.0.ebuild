# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-vFile-asData/Text-vFile-asData-0.80.0.ebuild,v 1.1 2013/01/28 19:14:42 tove Exp $

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Perl module to parse vFile formatted files into data structures"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Class-Accessor-Chained"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"
