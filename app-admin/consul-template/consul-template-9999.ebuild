# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 systemd user

KEYWORDS=""
DESCRIPTION="Generic template rendering and notifications with Consul"
GO_PN="github.com/hashicorp/${PN}"
HOMEPAGE="http://${GO_PN}"
EGIT_REPO_URI="git://${GO_PN}.git"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

DEPEND=">=dev-lang/go-1.4:=
	test? ( dev-go/go-tools )
	app-admin/consul
	app-admin/vault"
RDEPEND=""

SRC_URI=""
STRIP_MASK="*.a"
S="${WORKDIR}/src/${GO_PN}"
EGIT_CHECKOUT_DIR="${S}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_unpack() {
	export GOPATH=${WORKDIR}
	git-r3_src_unpack
	go get -d -v ./... $(go list -f '{{range .TestImports}}{{.}} {{end}}' ./...) || die
}

src_prepare() {
	sed -e 's|build: deps|build:|'  -e 's|test: deps|test:|' \
		-i Makefile || die

	# Disable tests that fail under network-sandbox
	sed -e 's:TestRun_onceFlag(:_\0:' -i cli_test.go || die
	sed -e 's:TestRunner_quiescence(:_\0:' -i runner_test.go || die
}

src_compile() {
	emake build
}

src_install() {
	local x

	dobin bin/${PN}
	dodoc README.md

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example
}
