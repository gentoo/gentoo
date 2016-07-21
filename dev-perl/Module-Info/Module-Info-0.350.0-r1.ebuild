# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Module-Info
MODULE_AUTHOR=MBARBON
MODULE_VERSION=0.35
inherit perl-module

DESCRIPTION="Information about Perl modules"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
