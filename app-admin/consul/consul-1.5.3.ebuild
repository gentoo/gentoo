# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot systemd user
GIT_COMMIT="a42ded4"
KEYWORDS="~amd64"
EGO_PN="github.com/hashicorp/consul"
DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="https://www.consul.io"
SRC_URI="https://github.com/hashicorp/consul/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT"
IUSE=""

RESTRICT="test"

DEPEND="dev-go/gox
	>=dev-lang/go-1.11:=
	>=dev-go/go-tools-0_pre20160121"
RDEPEND=""

pkg_setup() {
	enewgroup consul
	enewuser consul -1 -1 /var/lib/${PN} consul
}

src_prepare() {
	default

	# avoid network-sandbox violations since go-1.13
	rm src/${EGO_PN}/go.mod || die
	grep -rlZ '_ "github.com/envoyproxy/protoc-gen-validate/validate"' . | \
		xargs -0 sed -i '/_ "github.com\/envoyproxy\/protoc-gen-validate\/validate"/d' || die

	sed -e 's:go get -u -v $(GOTOOLS)::' \
		-e 's:vendorfmt dev-build:dev-build:' \
		-i "src/${EGO_PN}/GNUmakefile" || die
}

src_compile() {
	# The dev target sets causes build.sh to set appropriate XC_OS
	# and XC_ARCH, and skips generation of an unused zip file,
	# avoiding a dependency on app-arch/zip.
	GOPATH="${S}" \
	GOBIN="${S}/bin" \
	GIT_DESCRIBE="v${PV}" \
	GIT_DIRTY="" \
	GIT_COMMIT="${GIT_COMMIT}" \
	emake -C "src/${EGO_PN}" dev-build
}

src_install() {
	local x

	dobin bin/consul

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners consul:consul "${x}"
	done

	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/consul.service"
}
