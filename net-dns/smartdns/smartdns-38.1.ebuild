# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd
DESCRIPTION="A local DNS server returns the fastest access results"
HOMEPAGE="https://github.com/pymumu/smartdns"
SRC_URI="https://github.com/pymumu/smartdns/archive/refs/tags/Release${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-Release${PV}"

src_prepare() {
	default
	sed -i -e "/install .*default /d" \
		-e "/install .*init.d /d" Makefile || die
}

src_install() {
	emake DESTDIR="${D}" \
		SYSTEMDSYSTEMUNITDIR="$(systemd_get_systemunitdir)" install

	newconfd "${FILESDIR}"/smartdns.confd smartdns
	newinitd "${FILESDIR}"/smartdns.initd smartdns
}
