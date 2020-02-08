# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Set of IPv6 security/trouble-shooting tools to send arbitrary IPv6-based packets"
HOMEPAGE="https://www.si6networks.com/tools/ipv6toolkit/"
SNAPSHOT="20de5f297f73b6a8115d1eac52adfe0b6df5b3ed"
SRC_URI="https://github.com/fgont/ipv6toolkit/archive/${SNAPSHOT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/"${PN}"-"${SNAPSHOT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/libpcap[ipv6(+)]
"
RDEPEND="
	${DEPEND}
	sys-apps/hwids
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.1_p20190919-fno-common.patch
)

HWIDS_OUI_PATH=/usr/share/misc/oui.txt

src_prepare() {
	default
	sed -i "s#/usr/share/ipv6toolkit/oui.txt#${HWIDS_OUI_PATH}#" \
		manuals/ipv6toolkit.conf.5
}
src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" PREFIX=/usr
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
