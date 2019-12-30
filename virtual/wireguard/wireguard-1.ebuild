# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Simple yet fast and modern VPN that utilizes state-of-the-art cryptography."

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+module +tools"

RDEPEND="
	tools? ( net-vpn/wireguard-tools )
	module? ( net-vpn/wireguard-modules )
"

pkg_postinst() {
	ewarn
	ewarn "This package, ${CATEGORY}/${PN}, has been deprecated, in favor of explicitly"
	ewarn "merging the tools and the modules separately. You may accomplish this by"
	ewarn "running:"
	ewarn
	ewarn "    emerge -nO net-vpn/wireguard-tools net-vpn/wireguard-modules"
	ewarn "    emerge -C virtual/wireguard"
	ewarn
	ewarn "When Linux 5.6 comes out, net-vpn/wireguard-modules itself will be deprecated,"
	ewarn "with its functionality having moved directly into Linux."
	ewarn
}
