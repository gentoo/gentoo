# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module systemd

DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="https://www.consul.io"
GIT_COMMIT="bd257019c580a7f06b3ef99168698929b74f4bfc"

SRC_URI="https://github.com/zmedico/consul/archive/v${PV}-vendor.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT"
RESTRICT+=" test"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

BDEPEND="dev-go/gox"
COMMON_DEPEND="
	acct-group/consul
	acct-user/consul"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

S=${WORKDIR}/${P}-vendor

src_prepare() {
	default
	sed -e 's|^GIT_DATE=.*|GIT_DATE=2022-12-13T17:13:55Z|' -i GNUmakefile || die
}

src_compile() {
	# The dev target sets causes build.sh to set appropriate XC_OS
	# and XC_ARCH, and skips generation of an unused zip file,
	# avoiding a dependency on app-arch/zip.
	GIT_DESCRIBE="v${PV}" \
	GIT_DIRTY="" \
	GIT_COMMIT="${GIT_COMMIT}" \
	emake dev-build
}

src_install() {
	dobin bin/consul

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example

	keepdir /var/log/consul
	fowners consul:consul /var/log/consul

	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/consul.service"
}
