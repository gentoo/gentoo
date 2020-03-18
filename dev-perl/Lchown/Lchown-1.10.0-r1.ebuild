# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=NCLEATON
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Use the lchown(2) system call from Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build"
