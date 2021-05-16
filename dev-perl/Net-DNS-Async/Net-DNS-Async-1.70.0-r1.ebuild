# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SHEVEK
MODULE_VERSION=1.07
inherit perl-module

DESCRIPTION="Asynchronous DNS helper for high volume applications"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/Net-DNS"
DEPEND="${RDEPEND}"

SRC_TEST="do"

src_test() {
	# disable online test
	mv "${S}"/t/02_resolve.t{,.disable} || die
	perl-module_src_test
}
