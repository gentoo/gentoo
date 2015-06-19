# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Scope-Guard/Scope-Guard-0.200.0-r1.ebuild,v 1.1 2014/08/22 20:14:10 axs Exp $

EAPI=5

MODULE_AUTHOR=CHOCOLATE
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="Lexically scoped resource management"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
