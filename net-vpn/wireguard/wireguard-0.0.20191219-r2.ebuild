# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple yet fast and modern VPN that utilizes state-of-the-art cryptography."
HOMEPAGE="https://www.wireguard.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="debug +module +tools module-src"

RDEPEND="
	tools? ( net-vpn/wireguard-tools )
	module? ( net-vpn/wireguard-modules[module,debug?] )
	module-src? ( net-vpn/wireguard-modules[module-src] )
"
