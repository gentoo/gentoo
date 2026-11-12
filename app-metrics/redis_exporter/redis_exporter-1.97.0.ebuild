# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

EGIT_COMMIT=72d2a71f1f7c91fc4564083bc4c58655df85e5d0

DESCRIPTION="Prometheus Exporter for Redis Metrics. Supports Redis 2.x, 3.x and 4.x"
HOMEPAGE="https://github.com/oliver006/redis_exporter"
SRC_URI="https://github.com/oliver006/redis_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/redis_exporter
	acct-group/redis_exporter"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-lang/go-1.26.0
	test? (	dev-db/redis )
"

src_compile() {
	local egoldflags=(
		-X main.BuildVersion=${PV}
		-X main.BuildCommitSha=${EGIT_COMMIT}
		-X main.BuildDate=$(date +%F-%T)
	)
	ego build -o bin/ -ldflags="${egoldflags[*]}" ./...
}

src_test() {
	local redis_pid="${T}"/redis.pid
	local redis_port=6379

	if has_version ">=dev-db/redis-7"; then
		local extra_conf="
			enable-debug-command yes
			enable-module-command yes
		"
	fi

	# Spawn Redis itself for testing purposes
	einfo "Spawning Redis"
	einfo "NOTE: Port ${redis_port} must be free"
	"${EPREFIX}"/usr/sbin/redis-server - <<- EOF || die "Unable to start redis server"
		daemonize yes
		pidfile ${redis_pid}
		port ${redis_port}
		bind 127.0.0.1 ::1
		${extra_conf}
	EOF

	contrib/tls/gen-test-certs.sh || die "Unable to generate TLS certs"

	local -x TEST_REDIS_URI="redis://localhost:${redis_port}"
	ego test -work ./...

	# Clean up afterwards
	kill "$(<"${redis_pid}")" || die
}

src_install() {
	dobin bin/redis_exporter
	dodoc README.md

	local dir
	for dir in /var/{lib,log}/${PN}; do
		keepdir "${dir}"
		fowners ${PN}:${PN} "${dir}"
	done

	systemd_dounit "${FILESDIR}/${PN}.service"
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
