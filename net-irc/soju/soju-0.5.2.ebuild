# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="soju is a user-friendly IRC bouncer"
HOMEPAGE="https://soju.im/"
SRC_URI="https://git.sr.ht/~emersion/${PN}/refs/download/v${PV}/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="sqlite"

BDEPEND="
	app-text/scdoc
"
RDEPEND="
	acct-user/soju
	acct-group/soju
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}"

src_compile() {
	GOFLAGS+=" -tags=$(usex sqlite libsqlite3 nosqlite)"

	ego build ${GOFLAGS} ./cmd/soju
	ego build ${GOFLAGS} ./cmd/sojuctl

	scdoc <doc/soju.1.scd >doc/soju.1
}

src_install() {
	dobin soju
	dobin sojuctl

	doman doc/soju.1
	keepdir /etc/soju
	insinto /etc/soju
	newins config.in config
	newinitd "${FILESDIR}"/soju.initd soju
	einstalldocs
}

pkg_postinst() {
	elog "${PN} requires a user database for authenticating bouncer users,"
	elog "please create a user using:"
	elog "# sojuctl -config ${EROOT}/etc/soju/config create-user <username> [-admin]"
	elog "then set ${EROOT}/var/lib/soju/main.db owner and group to soju:soju."
}
