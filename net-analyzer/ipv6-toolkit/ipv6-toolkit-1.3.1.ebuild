# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Set of IPv6 security/trouble-shooting tools, that can send arbitrary IPv6-based packets"
HOMEPAGE="http://www.si6networks.com/tools/ipv6toolkit/"
MY_P="${PN}-v${PV}"
SRC_URI="http://www.si6networks.com/tools/ipv6toolkit/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libpcap[ipv6]"
RDEPEND="${DEPEND}
		 sys-apps/hwids"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/ipv6-toolkit-1.3.1-destdir.patch
	cd "${S}"
	sed -i 's,/usr/share/ipv6toolkit/oui.txt,/usr/share/misc/oui.txt,g' \
		data/ipv6toolkit.conf \
		manuals/ipv6toolkit.conf.5 \
		tools/scan6.c || die "failed to sed out oui path"
}

src_compile() {
	emake CFLAGS="-Wall ${CFLAGS}"
}

src_install() {
	emake install DESTDIR="${D}"
	rm -f "${D}"/usr/share/ipv6toolkit/oui.txt
	dodoc README* manuals/*{odt,pdf}
}
