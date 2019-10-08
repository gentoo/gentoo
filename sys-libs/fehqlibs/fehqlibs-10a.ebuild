# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="State-of-the-art C routines provided as easy-to-use library for Internet service"
HOMEPAGE="https://www.fehcom.de/ipnet/qlibs.html"
SRC_URI="https://www.fehcom.de/ipnet/fehQlibs/fehQlibs-${PV}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

S="${WORKDIR}/fehQlibs-${PV/a/}"

src_compile() {
	emake -j1
	emake -j1 shared
}

src_install() {
	dolib.a libqlibs.a libdnsresolv.a qlibs.a dnsresolv.a
	dolib.so libqlibs.so libdnsresolv.so

	mv include qlibs
	doheader -r qlibs
}
