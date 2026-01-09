# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info

DESCRIPTION="Kernel TLS helper utilities"
HOMEPAGE="https://github.com/oracle/ktls-utils"
SRC_URI="https://github.com/oracle/${PN}/archive/refs/tags/${P}.tar.gz"
S=${WORKDIR}/${PN}-${P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/glib
	dev-libs/libnl:3
	dev-libs/libyaml
	net-libs/gnutls
	sys-apps/keyutils
"
RDEPEND="${DEPEND}"
CONFIG_CHECK="~TLS ~KEYS ~KEYS_REQUEST_CACHE"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-systemd
}

src_install() {
	default
	dodoc README.md

	newinitd "${FILESDIR}/tlshd.initd" tlshd
}
