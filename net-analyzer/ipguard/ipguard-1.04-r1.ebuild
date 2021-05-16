# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool designed to protect LAN IP adress space by ARP spoofing"
HOMEPAGE="http://ipguard.deep.perm.ru/"
SRC_URI="http://ipguard.deep.perm.ru/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/libnet:1.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-init.d.patch
	"${FILESDIR}"/${P}-runpath.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_compile() {
	emake \
		CC=$(tc-getCC) \
		LIBNET_CONFIG="$(tc-getPKG_CONFIG) libnet" \
		PREFIX=\"${EPREFIX:-/usr}\"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIBNET_CONFIG="$(tc-getPKG_CONFIG) libnet" \
		PREFIX=\"${EPREFIX:-/usr}\" \
		install

	newinitd doc/${PN}.gentoo ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	dodoc doc/{NEWS,README*,ethers.sample}
}
