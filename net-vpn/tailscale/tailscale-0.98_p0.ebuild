# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd tmpfiles

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"

MY_PV="${PV//_p/-}"
MY_P="${PN}_${MY_PV}"
SRC_URI="
	amd64? ( https://pkgs.tailscale.com/stable/${MY_P}_amd64.tgz )
	arm? ( https://pkgs.tailscale.com/stable/${MY_P}_arm.tgz )
	arm64? ( https://pkgs.tailscale.com/stable/${MY_P}_arm64.tgz )
	x86? ( https://pkgs.tailscale.com/stable/${MY_P}_386.tgz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="net-firewall/iptables"

QA_PREBUILT="*"

src_unpack() {
	default
	use amd64 && S="${WORKDIR}/${MY_P}_amd64"
	use arm && S="${WORKDIR}/${MY_P}_arm"
	use arm64 && S="${WORKDIR}/${MY_P}_arm64"
	use x86 && S="${WORKDIR}/${MY_P}_386"
}

src_install() {
	dosbin ${PN}d
	dobin ${PN}

	systemd_dounit systemd/*.service
	insinto /etc/default
	newins systemd/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}
