# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PMISON
MODULE_VERSION=0.22
inherit perl-module

DESCRIPTION="Determine file type using magic"

SLOT="0"
KEYWORDS="amd64 hppa ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28"

SRC_TEST="do"
