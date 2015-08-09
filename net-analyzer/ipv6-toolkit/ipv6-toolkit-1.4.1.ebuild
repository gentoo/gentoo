# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Set of IPv6 security/trouble-shooting tools, that can send arbitrary IPv6-based packets"
HOMEPAGE="http://www.si6networks.com/tools/ipv6toolkit/"
MY_PN="ipv6toolkit"
MY_P="${MY_PN}-v${PV}"
SRC_URI="http://www.si6networks.com/tools/ipv6toolkit/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libpcap[ipv6]"
RDEPEND="${DEPEND}
		 sys-apps/hwids"

S="${WORKDIR}/${MY_P}"

HWIDS_OUI_PATH=/usr/share/misc/oui.txt

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.1-oui-path.patch
	cd "${S}"
	sed -i "s,/usr/share/[^[:space:]\"']*/?oui.txt,${HWIDS_OUI_PATH},g" \
		manuals/ipv6toolkit.conf.5 \
		|| die "failed to sed out oui path"
}

src_compile() {
	emake CFLAGS="-Wall ${CFLAGS}" OUI_DATABASE="${HWIDS_OUI_PATH}" PREFIX=/usr
}

src_install() {
	dodir /etc
	emake install DESTDIR="${D}" OUI_DATABASE="${HWIDS_OUI_PATH}" PREFIX=/usr
	rm -f "${D}"/usr/share/ipv6toolkit/oui.txt
	rmdir "${D}"/usr/share/ipv6toolkit
	dodoc CHANGES.TXT CONTRIB.TXT README*
}
pkg_postinst() {
	einfo "Upstream change: ${PN}-1.4: PDF/ODF documentation is now manpages only (same content)."
}
