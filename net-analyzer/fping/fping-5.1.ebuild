# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps

DESCRIPTION="A utility to ping multiple hosts at once"
HOMEPAGE="https://fping.org/ https://github.com/schweikert/fping/"
SRC_URI="https://fping.org/dist/${P}.tar.gz"

LICENSE="fping"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="suid"

FILECAPS=( cap_net_raw+ep usr/sbin/fping )

src_configure() {
	econf --enable-ipv6
}

src_install() {
	default

	if use suid; then
		fperms u+s /usr/sbin/fping
	fi

	dosym fping /usr/sbin/fping6
}
