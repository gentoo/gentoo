# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module user systemd
EGIT_COMMIT=55b9cfabb601b5a71822fa396f914a07a31dcbe4

DESCRIPTION="Prometheus Exporter for Redis Metrics. Supports Redis 2.x, 3.x and 4.x"
HOMEPAGE="https://github.com/oliver006/redis_exporter"
SRC_URI="https://github.com/oliver006/redis_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -e "s|\(^[[:space:]]*VERSION[[:space:]]*=[[:space:]]*\).*|\1\"${PV}\"|" \
		-e "s|\(^[[:space:]]*BUILD_DATE[[:space:]]*=[[:space:]]*\).*|\1\"$(LC_ALL=C date -u)\"|" \
		-e "s|\(^[[:space:]]*COMMIT_SHA1[[:space:]]*=[[:space:]]*\).*|\1\"${EGIT_COMMIT}\"|" \
		-i main.go || die

	sed -e 's:TestCommandStats(:_\0:' \
		-e 's:TestExportClientList(:_\0:' \
		-e 's:TestGetKeyInfo(:_\0:' \
		-e 's:TestGetKeysFromPatterns(:_\0:' \
		-e 's:TestHTTPEndpoints(:_\0:' \
		-e 's:TestHostVariations(:_\0:' \
		-e 's:TestIncludeSystemMemoryMetric(:_\0:' \
		-e 's:TestKeySizeList(:_\0:' \
		-e 's:TestKeysReset(:_\0:' \
		-e 's:TestKeyValuesAndSizes(:_\0:' \
		-e 's:TestLatencySpike(:_\0:' \
		-e 's:TestLuaScript(:_\0:' \
		-e 's:TestScanForKeys(:_\0:' \
		-e 's:TestSimultaneousRequests(:_\0:' \
		-e 's:TestSlowLog(:_\0:' \
		-i exporter_test.go || die
}

src_compile() {
	export GOBIN="${S}/bin"
	go install -mod=vendor \
		-ldflags="-X main.BuildVersion=${PV} -X main.BuildCommitSha=${EGIT_COMMIT} -X main.BuildDate=$(date +%F-%T)" \
		"${EGO_PN}" || die
}

src_test() {
	go test -work "${EGO_PN}" || die
}

src_install() {
	dobin "${GOBIN}/redis_exporter"
	dodoc README.md
	local dir
	for dir in /var/{lib,log}/${PN}; do
		keepdir "${dir}"
		fowners ${PN}:${PN} "${dir}"
	done
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}
