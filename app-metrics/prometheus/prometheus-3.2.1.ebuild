# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd eapi9-ver

GIT_COMMIT=804c49d58f3f3784c77c9c8ec17c9062092cae27
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
KEYWORDS="amd64 ~arm ~arm64 ~riscv"

COMMON_DEPEND="acct-group/prometheus
	acct-user/prometheus"
DEPEND="!app-metrics/prometheus-bin
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

BDEPEND=">=dev-util/promu-0.17.0"

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

	systemd_newunit "${FILESDIR}"/prometheus-3.2.service prometheus.service
	newinitd "${FILESDIR}"/prometheus-3.2.initd prometheus
	newconfd "${FILESDIR}"/prometheus-3.2.confd prometheus
	keepdir /var/log/prometheus /var/lib/prometheus
	fowners prometheus:prometheus /var/log/prometheus /var/lib/prometheus
}

pkg_postinst() {
	# added 2025-03-28 to warn about a fix for version 3.1.0
	if ver_replacing -eq 3.1.0; then
		ewarn "The systemd service has been renamed from prometheus-3 to prometheus."
	fi
	# added 2025-03-28 for version 3.2.1
	if ver_replacing -lt 3.2; then
		ewarn "The --web.enable-lifecycle and --web.enable-admin-api options have been removed"
		ewarn "from the default command line."
		ewarn "If you need these options, please enable them in /etc/prometheus/prometheus.yml"
		elog
		elog "The --web.listen-address option was removed from the default command line"
		elog "because we were using the default upstream setting."
	fi
}
