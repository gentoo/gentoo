# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CLKAO
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="PerlIO::via::symlink -  PerlIO layer for symlinks"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

DEPEND="dev-perl/Module-Install
	dev-perl/ExtUtils-AutoInstall"

src_prepare() {

	rm  -fr "${S}"/inc || die # bug 483812
}

SRC_TEST="do"
