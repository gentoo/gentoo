# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Compare the difference between numbers against a given tolerance"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

DEPEND="dev-perl/Module-Build"

SRC_TEST="do"
