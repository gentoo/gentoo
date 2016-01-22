# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base systemd user

GO_PN="github.com/hashicorp/consul"

DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="http://www.consul.io"
SRC_URI="
	https://github.com/hashicorp/consul/archive/v0.5.2.tar.gz -> ${P}.tar.gz
	https://github.com/armon/circbuf/archive/f092b4f207b6e5cce0569056fba9e1a2735cb6cf.tar.gz -> circbuf-f092b4f207b6e5cce0569056fba9e1a2735cb6cf.tar.gz
	https://github.com/armon/go-metrics/archive/a54701ebec11868993bc198c3f315353e9de2ed6.tar.gz -> go-metrics-a54701ebec11868993bc198c3f315353e9de2ed6.tar.gz
	https://github.com/armon/go-radix/archive/0bab926c3433cfd6490c6d3c504a7b471362390c.tar.gz -> go-radix-0bab926c3433cfd6490c6d3c504a7b471362390c.tar.gz
	https://github.com/armon/gomdb/archive/151f2e08ef45cb0e57d694b2562f351955dff572.tar.gz -> gomdb-151f2e08ef45cb0e57d694b2562f351955dff572.tar.gz
	https://github.com/boltdb/bolt/archive/2c04100eb9793f2b8541d243494e2909d2112325.tar.gz -> bolt-2c04100eb9793f2b8541d243494e2909d2112325.tar.gz
	https://github.com/hashicorp/consul-migrate/archive/v0.1.0.tar.gz -> consul-migrate-0.1.0.tar.gz
	https://github.com/hashicorp/go-checkpoint/archive/88326f6851319068e7b34981032128c0b1a6524d.tar.gz -> go-checkpoint-88326f6851319068e7b34981032128c0b1a6524d.tar.gz
	https://github.com/hashicorp/go-msgpack/archive/71c2886f5a673a35f909803f38ece5810165097b.tar.gz -> go-msgpack-71c2886f5a673a35f909803f38ece5810165097b.tar.gz
	https://github.com/hashicorp/go-multierror/archive/fcdddc395df1ddf4247c69bd436e84cfa0733f7e.tar.gz -> go-multierror-fcdddc395df1ddf4247c69bd436e84cfa0733f7e.tar.gz
	https://github.com/hashicorp/go-syslog/archive/42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz -> go-syslog-42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz
	https://github.com/hashicorp/golang-lru/archive/995efda3e073b6946b175ed93901d729ad47466a.tar.gz -> golang-lru-995efda3e073b6946b175ed93901d729ad47466a.tar.gz
	https://github.com/hashicorp/hcl/archive/513e04c400ee2e81e97f5e011c08fb42c6f69b84.tar.gz -> hcl-513e04c400ee2e81e97f5e011c08fb42c6f69b84.tar.gz
	https://github.com/hashicorp/logutils/archive/367a65d59043b4f846d179341d138f01f988c186.tar.gz -> logutils-367a65d59043b4f846d179341d138f01f988c186.tar.gz
	https://github.com/hashicorp/memberlist/archive/6025015f2dc659ca2c735112d37e753bda6e329d.tar.gz -> memberlist-6025015f2dc659ca2c735112d37e753bda6e329d.tar.gz
	https://github.com/hashicorp/net-rpc-msgpackrpc/archive/d377902b7aba83dd3895837b902f6cf3f71edcb2.tar.gz -> net-rpc-msgpackrpc-d377902b7aba83dd3895837b902f6cf3f71edcb2.tar.gz
	https://github.com/hashicorp/raft/archive/a8065f298505708bf60f518c09178149f3c06f21.tar.gz -> raft-a8065f298505708bf60f518c09178149f3c06f21.tar.gz
	https://github.com/hashicorp/raft-boltdb/archive/d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee.tar.gz -> raft-boltdb-d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee.tar.gz
	https://github.com/hashicorp/raft-mdb/archive/4ec3694ffbc74d34f7532e70ef2e9c3546a0c0b0.tar.gz -> raft-mdb-4ec3694ffbc74d34f7532e70ef2e9c3546a0c0b0.tar.gz
	https://github.com/hashicorp/scada-client/archive/c26580cfe35393f6f4bf1b9ba55e6afe33176bae.tar.gz -> scada-client-c26580cfe35393f6f4bf1b9ba55e6afe33176bae.tar.gz
	https://github.com/hashicorp/serf/archive/558a6876882b2c5c61df29fd3990fb1765fd71d3.tar.gz -> serf-558a6876882b2c5c61df29fd3990fb1765fd71d3.tar.gz
	https://github.com/hashicorp/yamux/archive/b2e55852ddaf823a85c67f798080eb7d08acd71d.tar.gz -> yamux-b2e55852ddaf823a85c67f798080eb7d08acd71d.tar.gz
	https://github.com/inconshreveable/muxado/archive/f693c7e88ba316d1a0ae3e205e22a01aa3ec2848.tar.gz -> muxado-f693c7e88ba316d1a0ae3e205e22a01aa3ec2848.tar.gz
	https://github.com/miekg/dns/archive/bb1103f648f811d2018d4bedcb2d4b2bce34a0f1.tar.gz -> dns-bb1103f648f811d2018d4bedcb2d4b2bce34a0f1.tar.gz
	https://github.com/mitchellh/cli/archive/6cc8bc522243675a2882b81662b0b0d2e04b99c9.tar.gz -> cli-6cc8bc522243675a2882b81662b0b0d2e04b99c9.tar.gz
	https://github.com/mitchellh/mapstructure/archive/442e588f213303bec7936deba67901f8fc8f18b1.tar.gz -> mapstructure-442e588f213303bec7936deba67901f8fc8f18b1.tar.gz
	https://github.com/ryanuber/columnize/archive/44cb4788b2ec3c3d158dd3d1b50aba7d66f4b59a.tar.gz -> columnize-44cb4788b2ec3c3d158dd3d1b50aba7d66f4b59a.tar.gz"

SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="~amd64"
IUSE="test web"

RESTRICT="test"

DEPEND="
	>=dev-lang/go-1.4:=
	dev-go/go-crypto:=
	test? ( dev-go/go-tools )
	web? (
		dev-ruby/sass
		dev-ruby/uglifier
	)"
RDEPEND=""

STRIP_MASK="*.a"

S="${WORKDIR}/src/${GO_PN}"

pkg_setup() {
	enewgroup consul
	enewuser consul -1 -1 /var/lib/${PN} consul
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
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			mkdir -p src/${go_package%/*} || die
			mv ${go_package##*/}-* src/${go_package} || die
		fi
	done
}

src_unpack() {
	local path
	unpack_go_packages
	# Create a writable GOROOT in order to avoid sandbox violations
	# or other interference from installed instances.
	export GOPATH="${WORKDIR}:$(get_golibdir_gopath)" GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	while read -r path; do
		rm -rf "${GOROOT}/src/${path#${WORKDIR}/src}" \
		"${GOROOT}/pkg/linux_${ARCH}/${path#${WORKDIR}/src}" || die
	done < <(find "${WORKDIR}"/src -maxdepth 3 -mindepth 3 -type d)
}

src_prepare() {
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' \
		-e 's:-X main.GitCommit.*:" \\:' \
		-i scripts/build.sh || die

	# Disable tests that fail under network-sandbox
	sed -e 's:TestServer_StartStop:_TestServer_StartStop:' \
		-i consul/server_test.go || die
	sed -e 's:TestRetryJoin(:_TestRetryJoin(:' \
		-i command/agent/command_test.go || die
}

src_compile() {
	emake

	if use web; then
		pushd ui >/dev/null || die
		emake dist
	fi
}

src_install() {
	local x

	dobin bin/*
	rm -rf bin || die

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example
	rm "${ED}etc/consul.d/ui.json.example" || die

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners consul:consul "${x}"
	done

	if use web; then
		insinto /var/lib/${PN}/ui
		doins -r ui/dist/*
	fi

	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"
	systemd_dounit "${FILESDIR}/consul.service"

	egit_clean "${WORKDIR}"/{pkg,src}

	find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type f -delete || die

	while read -r -d '' x; do
		x=${x#${WORKDIR}/src}
		[[ -d ${WORKDIR}/pkg/${KERNEL}_${ARCH}/${x} ||
			-f ${WORKDIR}/pkg/${KERNEL}_${ARCH}/${x}.a ]] && continue
		rm -rf "${WORKDIR}"/src/${x}
	done < <(find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type d -print0)
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto /usr/lib/go/pkg/${KERNEL}_${ARCH}/${GO_PN%/*}
	doins -r "${WORKDIR}"/pkg/${KERNEL}_${ARCH}/${GO_PN}
	insinto /usr/lib/go/src/${GO_PN%/*}
	doins -r "${WORKDIR}"/src/${GO_PN}
}
