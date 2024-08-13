# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="https://www.consul.io"
GIT_COMMIT="9fc827caf808b6ef1dc8c0748c3c4dce95d5b33a"
GIT_DATE="2024-05-16T19:10:00Z"

SRC_URI="https://github.com/hashicorp/consul/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"
LICENSE="BUSL-1.1 MPL-2.0"
LICENSE+=" Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="test"

BDEPEND="dev-go/gox"
COMMON_DEPEND="
	acct-group/consul
	acct-user/consul"
	DEPEND="${COMMON_DEPEND}"
	RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	default
	sed -e "s|^GIT_DATE=.*|GIT_DATE=${GIT_DATE}|" -i Makefile || die
}

src_compile() {
	if use x86; then
		#924629 pie breaks build on x86
		GOFLAGS=${GOFLAGS//-buildmode=pie}
	fi
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
