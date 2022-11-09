# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="A NTP (RFC-1305 and RFC-4330) client and server for unix-alike systems"
HOMEPAGE="https://github.com/troglobit/sntpd"
SRC_URI="https://github.com/troglobit/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="adjtimex systemd"

RDEPEND="systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_with adjtimex)
		$(use_with systemd systemd $(systemd_get_systemunitdir))
		--with-ntpclient
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/sntpd.initd-r1 sntpd
	newconfd "${FILESDIR}"/sntpd.confd sntpd
}
