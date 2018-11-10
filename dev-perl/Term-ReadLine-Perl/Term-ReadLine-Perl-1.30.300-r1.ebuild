# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ILYAZ
MODULE_SECTION=modules
MODULE_VERSION=1.0303

inherit perl-module

DESCRIPTION="Quick implementation of readline utilities"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="dev-perl/TermReadKey"

# bug 492212
#SRC_TEST="do parallel"
