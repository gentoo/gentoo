# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-mod-r1

DESCRIPTION="OpenVPN Data Channel Offload in the linux kernel"
HOMEPAGE="https://github.com/OpenVPN/ovpn-dco"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/OpenVPN/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenVPN/${PN}.git"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

PATCHES=(
	"${FILESDIR}"/0001-ovpn-dco-include-new-GSO-header-file.patch
)

pkg_setup() {
	CONFIG_CHECK="
		INET
		NET
		NET_UDP_TUNNEL
		DST_CACHE
		CRYPTO
		CRYPTO_AES
		CRYPTO_GCM
		CRYPTO_CHACHA20POLY1305"

	linux-mod-r1_pkg_setup
}

src_configure() {
	# Causes build failures because it builds with -pg,
	# bug #907744
	filter-flags -fomit-frame-pointer
	default
}

src_compile() {
	local modlist=( "ovpn-dco-v2=updates:.:drivers/net/ovpn-dco" )
	local modargs=( KERNEL_SRC="${KERNEL_DIR}" )
	[[ ${PV} != 9999 ]] && modargs+=( REVISION="${PV}" )
	use debug && modargs+=( DEBUG=1 )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	insinto /usr/share/${PN}
	doins -r include
}
