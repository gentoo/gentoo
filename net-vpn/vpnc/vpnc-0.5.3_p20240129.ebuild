# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd toolchain-funcs

DESCRIPTION="IPsec (Cisco/Juniper) VPN concentrator client"
HOMEPAGE="https://github.com/streambinder/vpnc"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/streambinder/vpnc.git"
else
	inherit vcs-snapshot
	SRC_URI="https://api.github.com/repos/streambinder/vpnc/tarball/64468ff -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv sparc x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="resolvconf gnutls selinux"

DEPEND="
	dev-libs/libgcrypt:=
	sys-apps/iproute2[-minimal]
	gnutls? ( net-libs/gnutls:= )
	!gnutls? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}
	>=net-vpn/vpnc-scripts-20210402-r1
	resolvconf? ( virtual/resolvconf )
	selinux? ( sec-policy/selinux-vpn )"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig"

CONFIG_CHECK="~TUN"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
	fi
}

src_configure() {
	tc-export CC PKG_CONFIG
	export OPENSSL_GPL_VIOLATION=$(usex !gnutls)
}

src_install() {
	local args=(
		PREFIX="${EPREFIX}"/usr
		DOCDIR='$(PREFIX)'/share/doc/${PF}
		SYSTEMDDIR="$(systemd_get_systemunitdir)"
		DESTDIR="${D}"
	)

	emake "${args[@]}" install

	keepdir /etc/vpnc/scripts.d
	newinitd "${FILESDIR}"/vpnc-3.init vpnc
	newconfd "${FILESDIR}"/vpnc.confd vpnc

	# LICENSE file resides here, should not be installed
	rm -r "${ED}"/usr/share/licenses || die
}

pkg_postinst() {
	elog "You can generate a configuration file from the original Cisco profiles of your"
	elog "connection by using /usr/bin/pcf2vpnc to convert the .pcf file"
	elog "A guide is available at https://wiki.gentoo.org/wiki/Vpnc"
}
