# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sub-Override/Sub-Override-0.90.0.ebuild,v 1.7 2013/05/25 08:00:14 ago Exp $

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl extension for easily overriding subroutines"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="test"

DEPEND="
	test? (
		>=dev-perl/Test-Fatal-0.10.0
	)"

SRC_TEST="do"
