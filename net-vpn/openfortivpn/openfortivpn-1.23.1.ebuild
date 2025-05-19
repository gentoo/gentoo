# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

DESCRIPTION="Fortinet compatible VPN client"
HOMEPAGE="https://github.com/adrienverge/openfortivpn"
SRC_URI="https://github.com/adrienverge/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3-with-openssl-exception openssl"
SLOT="0"
KEYWORDS="~amd64"
IUSE="resolvconf systemd"

DEPEND="
	dev-libs/openssl:=
	net-dialup/ppp
	resolvconf? ( virtual/resolvconf )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"

BDEPEND="
	virtual/pkgconfig
"

CONFIG_CHECK="~PPP ~PPP_ASYNC"

PATCHES=(
	"${FILESDIR}"/${PN}-1.02.3-systemd_substitute_bin_and_sysconfig_dirs.patch
	"${FILESDIR}"/${PN}-1.20.3-pppd-ipcp-accept-remote.patch
	"${FILESDIR}"/${P}-automagic.patch
)

src_prepare() {
	default

	sed -i 's/-Werror//g' Makefile.am || die "Failed to remove -Werror from Makefile.am"

	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable systemd)
	)

	use systemd && myconf+=(
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir)
	)

	use resolvconf || myconf+=(
		--with-resolvconf=DISABLED
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	keepdir /etc/openfortivpn
}

pkg_postinst() {
	if has_version "net-misc/networkmanager"; then
		ewarn "It is known that openfortivpn does not work in NetworkManager, but only"
		ewarn "as a terminal application. You can install net-vpn/networkmanager-openconnect"
		ewarn "to establish a connection to a Forti VPN in NetworkManager."
	fi
}
