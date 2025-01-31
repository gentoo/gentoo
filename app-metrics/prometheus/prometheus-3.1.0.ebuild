# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

GIT_COMMIT=7086161a93b262aa0949dbf2aba15a5a7b13e0a3
MY_PV=v${PV/_rc/-rc.}

# To create the assets tarball run the following:
# git checkout <tag>
# make assets-compress
# tar -acf <tarball> web/ui

DESCRIPTION="Prometheus monitoring system and time series database"
HOMEPAGE="https://prometheus.io"
SRC_URI="https://github.com/prometheus/prometheus/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz
	https://dev.gentoo.org/~williamh/dist/${P}-assets.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"

COMMON_DEPEND="acct-group/prometheus
	acct-user/prometheus"
DEPEND="!app-metrics/prometheus-bin
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

BDEPEND=">=dev-util/promu-0.3.0"

RESTRICT=" test"

src_prepare() {
	default
	sed -i \
		-e "s/{{.Branch}}/HEAD/" \
		-e "s/{{.Revision}}/${GIT_COMMIT}/" \
		-e "s/{{.Version}}/${PV}/" \
		.promu.yml || die
	cp -a -u "${WORKDIR}"/web/ui web || die "cp failed"
}

src_compile() {
	emake PROMU="${EPREFIX}"/usr/bin/promu common-build plugins
}

src_install() {
	dobin prometheus promtool
	dodoc -r documentation/{images,*.md} *.md docs
	insinto /etc/prometheus
	doins -r documentation/examples/prometheus.yml
	insinto /usr/share/prometheus
	doins -r documentation/examples

	systemd_dounit "${FILESDIR}"/prometheus-3.service
	newinitd "${FILESDIR}"/prometheus-3.initd prometheus
	newconfd "${FILESDIR}"/prometheus-3.confd prometheus
	keepdir /var/log/prometheus /var/lib/prometheus
	fowners prometheus:prometheus /var/log/prometheus /var/lib/prometheus
}
