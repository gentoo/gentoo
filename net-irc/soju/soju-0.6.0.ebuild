# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="soju is a user-friendly IRC bouncer"
HOMEPAGE="https://soju.im/"
SRC_URI="https://git.sr.ht/~emersion/${PN}/refs/download/v${PV}/${P}.tar.gz"
SRC_URI+=" https://github.com/alfredfo/${PN}-deps/raw/master/${P}-deps.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="pam"

BDEPEND="
	app-text/scdoc
"
RDEPEND="
	acct-user/soju
	acct-group/soju
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-fix-dup-upstream-connections.patch
)

src_compile() {
	GOFLAGS+=" -tags=moderncsqlite"
	use pam && GOFLAGS+=" -tags=pam"

	ego build ${GOFLAGS} ./cmd/soju
	ego build ${GOFLAGS} ./cmd/sojudb
	ego build ${GOFLAGS} ./cmd/sojuctl

	scdoc <doc/soju.1.scd >doc/soju.1 || die
}

src_install() {
	dobin soju
	dobin sojudb
	dobin sojuctl

	doman doc/soju.1
	systemd_dounit contrib/soju.service
	keepdir /etc/soju
	insinto /etc/soju
	newins config.in config
	newinitd "${FILESDIR}"/soju.initd soju
	einstalldocs
}

pkg_postinst() {
	elog "${PN} requires a user database for authenticating clients."
	elog "As the soju user, create a database using:"
	elog "$ sojudb -config ${EROOT}/etc/soju/config create-user <username> [-admin]"
}
