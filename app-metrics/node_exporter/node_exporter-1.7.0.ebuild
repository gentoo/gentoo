# Copyright 1999-2023 Gentoo Authors
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
	SRC_URI+=" https://github.com/rahilarious/gentoo-distfiles/releases/download/${P}/deps.tar.xz -> ${P}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
fi

# main pkg
LICENSE="Apache-2.0"
# deps
LICENSE+=" BSD BSD-2 MIT"
SLOT="0"
IUSE="selinux systemd"

RDEPEND="
	acct-group/node_exporter
	acct-user/node_exporter
	selinux? ( sec-policy/selinux-node_exporter )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/promu-0.3.0"
PATCHES=(
	 "${FILESDIR}"/01-default-settings-1.7.0.patch
)

src_prepare() {
	default
	use !systemd && { sed -i -e "s|defaultEnabled|defaultDisabled|g;" collector/systemd_linux.go || die; }
}

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	if use x86; then
		#917577 pie breaks build on x86
		GOFLAGS=${GOFLAGS//-buildmode=pie}
	fi
	promu build -v || die
	./"${PN}" --help-man > "${PN}".1 || die
}

src_test() {
	emake test-flags= test
}

src_install() {
	dosbin "${PN}"
	systemd_newunit "${FILESDIR}"/node_exporter-1.7.0.service node_exporter.service
	newinitd "${FILESDIR}"/${PN}.initd-1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/node_exporter-1.7.0.logrotate "${PN}"
	keepdir /var/lib/node_exporter /var/log/node_exporter
	fowners ${PN}:${PN} /var/lib/node_exporter /var/log/node_exporter

	doman "${PN}".1
	dodoc example-rules.yml *.md
}
