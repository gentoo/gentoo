# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Business-ISBN/Business-ISBN-2.50.0-r1.ebuild,v 1.1 2014/08/26 16:05:08 axs Exp $

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=2.05
inherit perl-module

DESCRIPTION="Work with ISBN as objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Business-ISBN-Data-20081208.0.0
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do

src_prepare() {
	perl-module_src_prepare
	sed -i '/URI/d' Makefile.PL || die # unused dependency
}

src_test() {
	mv t/xisbn10.t{,.disable} || die # online test
	sed -i 's,9997022576,9999922579,' t/isbn1{0,3}.t || die # non-existing block
	perl-module_src_test
}
