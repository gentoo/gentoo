# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-mod

DESCRIPTION="OpenVPN Data Channel Offload in the linux kernel"
HOMEPAGE="https://github.com/OpenVPN/ovpn-dco"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/OpenVPN/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ppc64 ~riscv x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenVPN/${PN}.git"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

MODULE_NAMES="ovpn-dco-v2(updates:.:drivers/net/ovpn-dco)"
BUILD_TARGETS="all"

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

	linux-mod_pkg_setup
}

src_configure() {
	# Causes build failures because it builds with -pg,
	# bug #907744
	filter-flags -fomit-frame-pointer
	default
}

src_compile() {
	BUILD_PARAMS+=" KERNEL_SRC='${KERNEL_DIR}'"
	[[ ${PV} != 9999 ]] && BUILD_PARAMS+=" REVISION='${PV}'"
	use debug && BUILD_PARAMS+=" DEBUG=1"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	insinto /usr/share/${PN}
	doins -r include
}
