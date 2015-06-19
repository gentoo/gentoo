# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-IxHash/Tie-IxHash-1.230.0.ebuild,v 1.12 2015/06/13 22:06:44 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=1.23
inherit perl-module

DESCRIPTION="Ordered associative arrays for Perl"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST=do
