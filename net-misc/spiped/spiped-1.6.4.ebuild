# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="${PN/d/}"
DESCRIPTION="secure pipe daemon"
HOMEPAGE="https://www.tarsnap.com/spiped.html"
SRC_URI="https://www.tarsnap.com/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/openssl:=
"
# Blocker added due to #548126
RDEPEND="
	${DEPEND}
	!net-mail/qlogtools
"

# Some tests fail because of too-long path for unix sockets.
RESTRICT="test"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${MY_PN}/${MY_PN}"
	dosbin "${PN}/${PN}"

	doman "${MY_PN}/${MY_PN}.1" "${PN}/${PN}.1"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	dodir "etc/${PN}"
}

pkg_postinst() {
	elog
	elog "You will need to configure spiped via its"
	elog "configuration file located in /etc/conf.d/."
	elog
	elog "Please have a look at this file prior to starting up spiped!"
	elog
}
