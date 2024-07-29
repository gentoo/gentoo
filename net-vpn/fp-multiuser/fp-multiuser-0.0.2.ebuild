# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd

DESCRIPTION="A frp server plugin to support multiple users for frp"
HOMEPAGE="https://github.com/gofrp/fp-multiuser"
SRC_URI="https://github.com/gofrp/fp-multiuser/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="
	acct-user/fp-multiuser
	acct-group/fp-multiuser"
DEPEND="${RDEPEND}"

src_compile() {
	emake all
}

src_install() {
	dobin bin/${PN}
	keepdir /etc/${PN}
	systemd_dounit "${FILESDIR}/fp-multiuser.service"
	newinitd "${FILESDIR}/initd" "${PN}"
	newconfd "${FILESDIR}/confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotated" "${PN}"
	dodoc README*.md
}
