# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MSHELOR
MODULE_VERSION=5.88
inherit perl-module

DESCRIPTION="Perl extension for SHA-1/224/256/384/512"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""

PATCHES=( "${FILESDIR}/${P}-CFLAGS.patch" )

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t t/podcover.t
	perl-module_src_test
}
