# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps

DESCRIPTION="Utility to ping multiple hosts at once"
HOMEPAGE="https://fping.org/ https://github.com/schweikert/fping/"
SRC_URI="
	https://fping.org/dist/${P}.tar.gz
	https://github.com/schweikert/fping/releases/download/v${PV}/${P}.tar.gz
"

LICENSE="fping"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
IUSE="debug suid"
# There are some tests in ci/* but they don't seem to be for packaging
# (they want to modify the live FS by e.g. copying to /tmp.)
RESTRICT="test"

FILECAPS=( cap_net_raw+ep usr/sbin/fping )

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-ipv6
}

src_install() {
	default

	if use suid; then
		fperms u+s /usr/sbin/fping
	fi

	dosym fping /usr/sbin/fping6
}
