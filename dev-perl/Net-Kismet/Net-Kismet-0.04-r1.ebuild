# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Module for writing perl Kismet clients"
SRC_URI="https://www.kismetwireless.net/code/${P}.tar.gz"
HOMEPAGE="https://www.kismetwireless.net"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ia64 ppc x86"
IUSE=""
SRC_TEST="do parallel"

src_compile() {
	perl-module_src_compile
	perl-module_src_test
}
