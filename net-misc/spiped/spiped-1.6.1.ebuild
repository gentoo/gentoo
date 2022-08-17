# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="secure pipe daemon"
HOMEPAGE="http://www.tarsnap.com/spiped.html"
SRC_URI="http://www.tarsnap.com/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MY_PN="${PN/d/}"

DEPEND="
	dev-libs/openssl:0="

# Blocker added due to #548126
RDEPEND="
	${DEPEND}
	!net-mail/qlogtools"

# Some tests fail.
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
