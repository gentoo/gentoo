# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHEVEK
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Asynchronous DNS helper for high volume applications"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-perl/Net-DNS"
BDEPEND="${RDEPEND}"

src_test() {
	# disable online test
	mv "${S}"/t/02_resolve.t{,.disable} || die
	perl-module_src_test
}
