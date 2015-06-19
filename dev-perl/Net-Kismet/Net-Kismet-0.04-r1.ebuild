# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Kismet/Net-Kismet-0.04-r1.ebuild,v 1.3 2014/06/12 20:05:16 zlogene Exp $

EAPI=5

inherit perl-module

DESCRIPTION="Module for writing perl Kismet clients"
SRC_URI="http://www.kismetwireless.net/code/${P}.tar.gz"
HOMEPAGE="http://www.kismetwireless.net"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ia64 ppc x86"
IUSE=""
SRC_TEST="do parallel"

src_compile() {
	perl-module_src_compile
	perl-module_src_test
}
