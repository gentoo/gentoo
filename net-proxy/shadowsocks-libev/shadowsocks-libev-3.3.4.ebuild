# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="v${PV}"
inherit autotools eutils systemd

DESCRIPTION="A lightweight secured SOCKS5 proxy for embedded devices and low end boxes"
HOMEPAGE="https://github.com/shadowsocks/shadowsocks-libev"

#repack with git submodule populated: libbloom, libcork, libipset
#SRC_URI="https://dev.gentoo.org/~dlan/distfiles/${P}.tar.xz"

SRC_URI="https://github.com/shadowsocks/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug doc"

RDEPEND="net-libs/mbedtls:=
	net-libs/libbloom
	net-libs/libcork
	net-libs/libcorkipset
	>=dev-libs/libsodium-1.0.8:=
	dev-libs/libev
	net-dns/c-ares
	dev-libs/libpcre
	"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	"

PATCHES=(
	"${FILESDIR}/${P}-gcc10.patch"
)
src_prepare() {
	sed -i 's|AC_CONFIG_FILES(\[libbloom/Makefile libcork/Makefile libipset/Makefile\])||' \
		configure.ac || die
	default
	eautoreconf
}

src_configure() {
	local myconf="
		$(use_enable debug assert)
		--enable-system-shared-lib
	"
	use doc || myconf+="--disable-documentation"
	econf ${myconf}
}

src_install() {
	default

	find "${D}" -name '*.la' -type f -delete || die

	insinto "/etc/${PN}"
	newins "${FILESDIR}/shadowsocks.json" shadowsocks.json

	newinitd "${FILESDIR}/shadowsocks.initd" shadowsocks
	dosym shadowsocks /etc/init.d/shadowsocks.server
	dosym shadowsocks /etc/init.d/shadowsocks.client
	dosym shadowsocks /etc/init.d/shadowsocks.redir
	dosym shadowsocks /etc/init.d/shadowsocks.tunnel

	dodoc -r acl

	systemd_newunit "${FILESDIR}/${PN}-local_at.service" "${PN}-local@.service"
	systemd_newunit "${FILESDIR}/${PN}-server_at.service" "${PN}-server@.service"
	systemd_newunit "${FILESDIR}/${PN}-redir_at.service" "${PN}-redir@.service"
	systemd_newunit "${FILESDIR}/${PN}-tunnel_at.service" "${PN}-tunnel@.service"
}

pkg_setup() {
	elog "You need to choose the mode"
	elog "  server: rc-update add shadowsocks.server default"
	elog "  client: rc-update add shadowsocks.client default"
	elog "  redir:  rc-update add shadowsocks.redir default"
	elog "  tunnel: rc-update add shadowsocks.tunnel default"
}
