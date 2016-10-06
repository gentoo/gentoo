# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Set of IPv6 security/trouble-shooting tools to send arbitrary IPv6-based packets"
HOMEPAGE="http://www.si6networks.com/tools/ipv6toolkit/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/fgont/ipv6toolkit.git"
	inherit git-r3
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SNAPSHOT="d14d90969e88a455e4ca8ea0ea7d88c9b7fb5c9f"
	SRC_URI="https://github.com/fgont/ipv6toolkit/archive/${SNAPSHOT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/"${PN}"-"${SNAPSHOT}"
fi

DEPEND="net-libs/libpcap[ipv6(+)]"
RDEPEND="${DEPEND}
	sys-apps/hwids"

HWIDS_OUI_PATH=/usr/share/misc/oui.txt

src_prepare() {
	sed -i "s#/usr/share/ipv6toolkit/oui.txt#${HWIDS_OUI_PATH}#" \
		manuals/ipv6toolkit.conf.5
}
src_compile() {
	emake CFLAGS="${CFLAGS}" PREFIX=/usr
}

src_install() {
	dodir /etc
	emake install DESTDIR="${ED}" PREFIX=/usr
	#remove the included oui file
	rm -f "${D}"/usr/share/ipv6toolkit/oui.txt
	#fix the conf file to use the one from sys-apps/hwids
	sed -i "s#/usr/share/ipv6toolkit/oui.txt#${HWIDS_OUI_PATH}#" \
		"${ED}"/etc/ipv6toolkit.conf
	dodoc CHANGES.TXT README.TXT
}
