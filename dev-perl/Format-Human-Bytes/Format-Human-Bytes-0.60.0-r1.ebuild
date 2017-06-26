# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SEWI
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Format a bytecount and make it human readable"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST=do

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
