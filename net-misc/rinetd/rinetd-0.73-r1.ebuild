# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="redirects TCP connections from one IP address and port to another"
HOMEPAGE="https://github.com/samhocevar/rinetd"
SRC_URI="https://github.com/samhocevar/rinetd/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	default

	newinitd "${FILESDIR}"/rinetd.rc rinetd
	systemd_dounit "${FILESDIR}"/rinetd.service
}
