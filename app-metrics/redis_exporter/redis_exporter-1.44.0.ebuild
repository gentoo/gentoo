# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd
EGIT_COMMIT=19f7b036bb46869858eec74d8d3fc2186d641399

DESCRIPTION="Prometheus Exporter for Redis Metrics. Supports Redis 2.x, 3.x and 4.x"
HOMEPAGE="https://github.com/oliver006/redis_exporter"
SRC_URI="https://github.com/oliver006/redis_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="
	acct-user/redis_exporter
	acct-group/redis_exporter"
DEPEND="${RDEPEND}"
RESTRICT+=" test"

src_prepare() {
	default
	sed -e "s|\(^[[:space:]]*VERSION[[:space:]]*=[[:space:]]*\).*|\1\"${PV}\"|" \
		-e "s|\(^[[:space:]]*BUILD_DATE[[:space:]]*=[[:space:]]*\).*|\1\"$(LC_ALL=C date -u)\"|" \
		-e "s|\(^[[:space:]]*COMMIT_SHA1[[:space:]]*=[[:space:]]*\).*|\1\"${EGIT_COMMIT}\"|" \
		-i main.go || die
}

src_compile() {
	export GOBIN="${S}/bin"
	go install \
		-ldflags="-X main.BuildVersion=${PV} -X main.BuildCommitSha=${EGIT_COMMIT} -X main.BuildDate=$(date +%F-%T)" \
		./... || die
}

src_test() {
	go test -work ./... || die
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
