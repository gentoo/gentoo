# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="State-of-the-art C routines provided as easy-to-use library for Internet service"
HOMEPAGE="https://www.fehcom.de/ipnet/qlibs.html"
SRC_URI="https://www.fehcom.de/ipnet/fehQlibs/fehQlibs-${PV}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/fehQlibs-${PV/a/}"

src_prepare() {
	sed -i 's/CC="cc"/CC="${CC:-cc}"/' configure || die
	default
}

src_compile() {
	emake -j1
}

src_install() {
	dolib.a libqlibs.a libdnsresolv.a qlibs.a dnsresolv.a

	mv include qlibs || die
	doheader -r qlibs
}
