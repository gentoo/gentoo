# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/B-Hooks-Parser/B-Hooks-Parser-0.130.0.ebuild,v 1.1 2015/07/01 13:04:30 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Interface to perls parser variables"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/B-Hooks-OP-Check"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302
	test? ( dev-perl/Test-Exception
		dev-perl/B-Hooks-EndOfScope )"
SRC_TEST=do
