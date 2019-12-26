# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

DESCRIPTION="Required tools for WireGuard, such as wg(8) and wg-quick(8)"
HOMEPAGE="https://www.wireguard.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.zx2c4.com/wireguard-tools"
	KEYWORDS=""
else
	SRC_URI="https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${PV}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="net-libs/libmnl"
RDEPEND="${DEPEND}
	|| ( net-firewall/nftables net-firewall/iptables )
	!<=net-vpn/wireguard-0.0.20191219
"

src_compile() {
	emake RUNSTATEDIR="${EPREFIX}/run" -C src CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	dodoc README.md
	dodoc -r contrib
	emake \
		WITH_BASHCOMPLETION=yes \
		WITH_SYSTEMDUNITS=yes \
		WITH_WGQUICK=yes \
		DESTDIR="${D}" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		PREFIX="${EPREFIX}/usr" \
		-C src install
}
