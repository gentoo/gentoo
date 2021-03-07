# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot systemd

EGO_PN="github.com/oliver006/redis_exporter"
EGIT_COMMIT="3e15af27aac37e114b32a07f5e9dc0510f4cbfc4"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus Exporter for Redis Metrics. Supports Redis 2.x, 3.x and 4.x"
HOMEPAGE="https://github.com/oliver006/redis_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
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
		-i src/${EGO_PN}/main.go || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #684052
	pushd src/${EGO_PN} || die
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	popd || die
}

src_install() {
	dobin bin/redis_exporter
	dodoc src/${EGO_PN}/README.md
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
