# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

GIT_COMMIT="3831febfb003370d3544ff6f71ba4eeea0b92772"
GIT_DATE="2025-11-26T05:53:08Z" # source build-support/functions/10-util.sh; git_date

DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="https://www.consul.io"
SRC_URI="https://github.com/hashicorp/consul/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="BUSL-1.1 MPL-2.0"
# Dependent licenses
LICENSE+=" AFL-2.1 Apache-2.0 Artistic Artistic-2 BEER-WARE Boost-1.0 BSD BSD-2 BSD-4 CC-BY-3.0 CC-BY-4.0 CC-BY-SA-2.0 CC-BY-SA-3.0 CC-BY-SA-4.0 GPL-1 GPL-2 GPL-3 ISC LGPL-2 LGPL-2.1 LGPL-3 LPPL-1.3c MIT MPL-2.0 Ms-PL OFL-1.1 openssl OSL-1.1 RSA Sleepycat Unicode-DFS-2016 UoI-NCSA WTFPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="test"

DEPEND="
	acct-group/consul
	acct-user/consul
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.25.4"

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

	systemd_dounit "${FILESDIR}/consul.service"
	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
