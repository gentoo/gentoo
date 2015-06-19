# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/consul-template/consul-template-0.9.0.ebuild,v 1.1 2015/05/26 03:54:54 zmedico Exp $

EAPI=5

inherit systemd user

KEYWORDS="~amd64"
DESCRIPTION="Generic template rendering and notifications with Consul"
GO_PN="github.com/hashicorp/${PN}"
HOMEPAGE="http://${GO_PN}"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

DEPEND=">=dev-lang/go-1.4
	test? ( dev-go/go-tools )
	app-admin/consul
	app-admin/vault"
RDEPEND=""

SRC_URI="https://${GO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/hashicorp/go-multierror/archive/fcdddc395df1ddf4247c69bd436e84cfa0733f7e.tar.gz -> go-multierror-fcdddc395df1ddf4247c69bd436e84cfa0733f7e.tar.gz
https://github.com/armon/go-radix/archive/0bab926c3433cfd6490c6d3c504a7b471362390c.tar.gz -> go-radix-0bab926c3433cfd6490c6d3c504a7b471362390c.tar.gz
https://github.com/hashicorp/errwrap/archive/7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz -> errwrap-7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz
https://github.com/armon/go-metrics/archive/a54701ebec11868993bc198c3f315353e9de2ed6.tar.gz -> go-metrics-a54701ebec11868993bc198c3f315353e9de2ed6.tar.gz
https://github.com/hashicorp/go-msgpack/archive/71c2886f5a673a35f909803f38ece5810165097b.tar.gz -> go-msgpack-71c2886f5a673a35f909803f38ece5810165097b.tar.gz
https://github.com/hashicorp/go-syslog/archive/42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz -> go-syslog-42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz
https://github.com/hashicorp/golang-lru/archive/995efda3e073b6946b175ed93901d729ad47466a.tar.gz -> golang-lru-995efda3e073b6946b175ed93901d729ad47466a.tar.gz
https://github.com/hashicorp/hcl/archive/513e04c400ee2e81e97f5e011c08fb42c6f69b84.tar.gz -> hcl-513e04c400ee2e81e97f5e011c08fb42c6f69b84.tar.gz
https://github.com/hashicorp/logutils/archive/367a65d59043b4f846d179341d138f01f988c186.tar.gz -> logutils-367a65d59043b4f846d179341d138f01f988c186.tar.gz
https://github.com/mitchellh/copystructure/archive/6fc66267e9da7d155a9d3bd489e00dad02666dc6.tar.gz -> copystructure-6fc66267e9da7d155a9d3bd489e00dad02666dc6.tar.gz
https://github.com/mitchellh/mapstructure/archive/442e588f213303bec7936deba67901f8fc8f18b1.tar.gz -> mapstructure-442e588f213303bec7936deba67901f8fc8f18b1.tar.gz
https://github.com/mitchellh/reflectwalk/archive/242be0c275dedfba00a616563e6db75ab8f279ec.tar.gz -> reflectwalk-242be0c275dedfba00a616563e6db75ab8f279ec.tar.gz
https://github.com/samuel/go-zookeeper/archive/d0e0d8e11f318e000a8cc434616d69e329edc374.tar.gz -> go-zookeeper-d0e0d8e11f318e000a8cc434616d69e329edc374.tar.gz"
STRIP_MASK="*.a"
S="${WORKDIR}/src/${GO_PN}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

get_archive_go_package() {
	local archive=${1} uri x
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	echo ${uri%/archive/*}
}

unpack_go_packages() {
	local go_package x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		go_package=$(get_archive_go_package ${x})
		mkdir -p src/${go_package%/*}
		mv ${go_package##*/}-* src/${go_package} || die
	done
}

src_unpack() {
	unpack_go_packages
	export GOPATH=${WORKDIR}
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
