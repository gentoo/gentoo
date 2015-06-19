# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-ShowTable/Data-ShowTable-3.300.0-r1.ebuild,v 1.2 2015/06/16 19:58:41 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=AKSTE
MODULE_VERSION=3.3
inherit perl-module

DESCRIPTION="routines to display tabular data in several formats"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

PATCHES=( "${FILESDIR}"/3.3.patch )
SRC_TEST=do

src_test() {
	# bug 403881
	perl_rm_files t/list-wrap.t
	perl-module_src_test
}

src_install () {
	perl-module_src_install
	dohtml *.html
}
