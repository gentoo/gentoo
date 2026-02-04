# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/prometheus/node_exporter.git"
else
	SRC_URI="https://github.com/prometheus/node_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

	KEYWORDS="amd64 arm64 ~loong ~riscv ~x86"
fi

# main pkg
LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
IUSE="selinux"

DEPEND="
	acct-group/node_exporter
	acct-user/node_exporter
	selinux? ( sec-policy/selinux-node_exporter )
"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		default
	fi
}

src_compile() {
	if use x86; then
		#917577 pie breaks build on x86
		GOFLAGS=${GOFLAGS//-buildmode=pie}
	fi
	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${GIT_COMMIT}
		-X github.com/prometheus/common/version.Branch=master
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%F-%T)"
	)
	ego build -mod=vendor -ldflags "${go_ldflags[*]}" -o ${PN} .
	./"${PN}" --help-man > "${PN}".1 || die
}

src_test() {
	emake test-flags= test
}

src_install() {
	dosbin "${PN}"
	dodoc example-rules.yml *.md
	doman "${PN}".1

	systemd_dounit examples/systemd/node_exporter.{service,socket}
	newinitd "${FILESDIR}"/${PN}.initd-1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	insinto /etc/sysconfig
	newins examples/systemd/sysconfig.node_exporter node_exporter

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/node_exporter-1.7.0.logrotate "${PN}"

	keepdir /var/lib/node_exporter/textfile_collector /var/log/node_exporter
	fowners -R ${PN}:${PN} /var/lib/node_exporter /var/log/node_exporter
}
