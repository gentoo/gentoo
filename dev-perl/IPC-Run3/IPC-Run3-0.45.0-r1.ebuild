# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.045
inherit perl-module

DESCRIPTION="Run a subprocess in batch mode (a la system)"

LICENSE="|| ( BSD-2 Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Pod-1.00
		>=dev-perl/Test-Pod-Coverage-1.04
	)"

SRC_TEST="do"
