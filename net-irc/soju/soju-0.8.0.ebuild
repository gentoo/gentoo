# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit go-module systemd

DESCRIPTION="soju is a user-friendly IRC bouncer"
HOMEPAGE="https://soju.im/"
SRC_URI="https://git.sr.ht/~emersion/${PN}/refs/download/v${PV}/${P}.tar.gz"
SRC_URI+=" https://github.com/alfredfo/${PN}-deps/raw/master/${P}-deps.tar.xz"

LICENSE="AGPL-3 Apache-2.0 MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"
IUSE="moderncsqlite +sqlite pam"
REQUIRED_USE="?? ( moderncsqlite sqlite )"

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
	# musl removed legacy LFS64 interfaces in version 1.2.4 temporarily
	# reenabled using _LARGEFILE64_SOURCE until this is resolved
	# upstream https://github.com/mattn/go-sqlite3/issues/1164
	CGO_CFLAGS="${CGO_CFLAGS}"
	if use sqlite; then
		GOFLAGS+=" -tags=libsqlite3"
		CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
	elif use moderncsqlite; then
		GOFLAGS+=" -tags=moderncsqlite"
		CGO_CFLAGS="-D_LARGEFILE64_SOURCE"
	else
		GOFLAGS+=" -tags=nosqlite"
	fi
	# Only way to pass CFLAGS to CGO at the
	# moment. https://github.com/gentoo/gentoo/pull/33539/
	export CGO_CFLAGS
	use pam && GOFLAGS+=" -tags=pam"

	ego build ${GOFLAGS} ./cmd/soju
	ego build ${GOFLAGS} ./cmd/sojudb
	ego build ${GOFLAGS} ./cmd/sojuctl

	scdoc <doc/soju.1.scd >doc/soju.1 || die
	scdoc <doc/sojuctl.1.scd >doc/sojuctl.1 || die
}

src_install() {
	dobin soju
	dobin sojudb
	dobin sojuctl

	doman doc/soju.1
	doman doc/sojuctl.1
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
