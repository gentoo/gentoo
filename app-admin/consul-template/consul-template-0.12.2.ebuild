# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base systemd user

KEYWORDS="~amd64"
DESCRIPTION="Generic template rendering and notifications with Consul"
EGO_PN="github.com/hashicorp/${PN}/..."
HOMEPAGE="http://${EGO_PN%/*}"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

DEPEND=">=dev-lang/go-1.4:="
RDEPEND=""

SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/fatih/structs/archive/a924a2250d1033753512e95dce41dca3fd793ad9.tar.gz -> structs-a924a2250d1033753512e95dce41dca3fd793ad9.tar.gz
	https://github.com/go-yaml/yaml/archive/f7716cbe52baa25d2e9b0d0da546fcf909fc16b4.tar.gz -> go-yaml-v2-f7716cbe52baa25d2e9b0d0da546fcf909fc16b4.tar.gz
	https://github.com/golang/sys/archive/58da1121af381632b48b2843aeb16299f2e1dc50.tar.gz -> go-sys-0_pre20150729.tar.gz
	https://github.com/hashicorp/consul/archive/v0.6.3.tar.gz -> consul-0.6.3.tar.gz
	https://github.com/hashicorp/go-cleanhttp/archive/ce617e79981a8fff618bb643d155133a8f38db96.tar.gz -> go-cleanhttp-ce617e79981a8fff618bb643d155133a8f38db96.tar.gz
	https://github.com/hashicorp/errwrap/archive/7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz -> errwrap-7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz
	https://github.com/hashicorp/go-multierror/archive/d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5.tar.gz -> go-multierror-d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5.tar.gz
	https://github.com/hashicorp/go-reap/archive/2d85522212dcf5a84c6b357094f5c44710441912.tar.gz -> go-reap-2d85522212dcf5a84c6b357094f5c44710441912.tar.gz
	https://github.com/hashicorp/go-syslog/archive/42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz -> go-syslog-42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz
	https://github.com/hashicorp/hcl/archive/578dd9746824a54637686b51a41bad457a56bcef.tar.gz -> hcl-578dd9746824a54637686b51a41bad457a56bcef.tar.gz
	https://github.com/hashicorp/logutils/archive/0dc08b1671f34c4250ce212759ebd880f743d883.tar.gz -> logutils-0dc08b1671f34c4250ce212759ebd880f743d883.tar.gz
	https://github.com/hashicorp/serf/archive/64d10e9428bd70dbcd831ad087573b66731c014b.tar.gz -> serf-64d10e9428bd70dbcd831ad087573b66731c014b.tar.gz
	https://github.com/hashicorp/vault/archive/145041757cee09193b0d132b816f72bc1e846107.tar.gz -> vault-145041757cee09193b0d132b816f72bc1e846107.tar.gz
	https://github.com/mitchellh/mapstructure/archive/281073eb9eb092240d33ef253c404f1cca550309.tar.gz -> mapstructure-281073eb9eb092240d33ef253c404f1cca550309.tar.gz
	test? (
		https://github.com/armon/go-metrics/archive/345426c77237ece5dab0e1605c3e4b35c3f54757.tar.gz -> go-metrics-345426c77237ece5dab0e1605c3e4b35c3f54757.tar.gz
		https://github.com/armon/go-radix/archive/4239b77079c7b5d1243b7b4736304ce8ddb6f0f2.tar.gz -> go-radix-4239b77079c7b5d1243b7b4736304ce8ddb6f0f2.tar.gz
		https://github.com/aws/aws-sdk-go/archive/v1.0.11.tar.gz -> aws-sdk-go-1.0.11.tar.gz
		https://github.com/coreos/etcd/archive/5099bf6f7ab92181158cc2f0f0db1bb6056e9aeb.tar.gz -> etcd-5099bf6f7ab92181158cc2f0f0db1bb6056e9aeb.tar.gz
		https://github.com/go-ini/ini/archive/v1.8.6.tar.gz -> go-ini-1.8.6.tar.gz
		https://github.com/go-sql-driver/mysql/archive/v1.2.tar.gz -> go-sql-driver-mysql-1.2.tar.gz
		https://github.com/golang/crypto/archive/83f1503f771a82af8a31f358eb825e9efb5dae6c.tar.gz -> go-crypto-0_pre20150808.tar.gz
		https://github.com/golang/net/archive/1bc0720082d79ce7ffc6ef6e523d00d46b0dee45.tar.gz -> go-net-0_pre20150804.tar.gz
		https://github.com/hashicorp/consul/archive/v0.6.3.tar.gz -> consul-0.6.3.tar.gz
		https://github.com/hashicorp/go-gatedio/archive/8b8de1022221dde1fb52fa25d0caab46e59c8c14.tar.gz -> go-gatedio-8b8de1022221dde1fb52fa25d0caab46e59c8c14.tar.gz
		https://github.com/hashicorp/go-msgpack/archive/fa3f63826f7c23912c15263591e65d54d080b458.tar.gz -> go-msgpack-fa3f63826f7c23912c15263591e65d54d080b458.tar.gz
		https://github.com/hashicorp/go-uuid/archive/36289988d83ca270bc07c234c36f364b0dd9c9a7.tar.gz -> go-uuid-36289988d83ca270bc07c234c36f364b0dd9c9a7.tar.gz
		https://github.com/hashicorp/golang-lru/archive/5c7531c003d8bf158b0fe5063649a2f41a822146.tar.gz -> golang-lru-5c7531c003d8bf158b0fe5063649a2f41a822146.tar.gz
		https://github.com/hashicorp/uuid/archive/2951e8b9707a040acdb49145ed9f36a088f3532e.tar.gz -> uuid-2951e8b9707a040acdb49145ed9f36a088f3532e.tar.gz
		https://github.com/jmespath/go-jmespath/archive/0.2.2.tar.gz -> go-jmespath-0.2.2.tar.gz
		https://github.com/mitchellh/copystructure/archive/6fc66267e9da7d155a9d3bd489e00dad02666dc6.tar.gz -> copystructure-6fc66267e9da7d155a9d3bd489e00dad02666dc6.tar.gz
		https://github.com/mitchellh/reflectwalk/archive/eecf4c70c626c7cfbb95c90195bc34d386c74ac6.tar.gz -> reflectwalk-eecf4c70c626c7cfbb95c90195bc34d386c74ac6.tar.gz
		https://github.com/samuel/go-zookeeper/archive/218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f.tar.gz -> go-zookeeper-218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f.tar.gz
	)"

STRIP_MASK="*.a"
S="${WORKDIR}/src/${EGO_PN%/*}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

get_archive_go_package() {
	local archive=${1} uri x
	case ${archive} in
		go-crypto-*) echo "crypto-* golang.org/x/crypto"; return;;
		go-net-*) echo "net-* golang.org/x/net"; return;;
		go-sys-*) echo "sys-* golang.org/x/sys"; return;;
		go-yaml-v2-*) echo "yaml-* gopkg.in/yaml.v2"; return;;
	esac
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	uri=${uri%/archive/*}
	echo "${uri##*/}-* ${uri}"
}

unpack_go_packages() {
	local go_package pattern x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		go_package=$(get_archive_go_package ${x})
		pattern=${go_package%% *}
		go_package=${go_package##* }
		mkdir -p src/${go_package%/*}
		mv ${pattern} src/${go_package} || die
	done
}

src_unpack() {
	unpack_go_packages
	export GOPATH=${WORKDIR}:$(get_golibdir_gopath)
}

src_prepare() {
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' \
		-e 's:-ldflags.*:\\:' \
		-i scripts/build.sh || die

	# Create a writable GOROOT in order to avoid sandbox violations.
	export GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}"/{src,pkg/$(go env GOOS)_$(go env GOARCH)}/"${EGO_PN%/*}" || die

	# Prune conflicting libraries from GOROOT
	while read -r -d '' x; do
		x=${x#${WORKDIR}/src}
		rm -rf "${GOROOT}/src/${x}" "${GOROOT}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}"{,.a} || die
	done < <(find "${WORKDIR}/src" -maxdepth 3 -mindepth 3 -type d -print0)

	# Disable tests that fail under network-sandbox
	sed -e 's:TestRun_onceFlag(:_\0:' -i cli_test.go || die
	sed -e 's:TestRunner_quiescence(:_\0:' -i runner_test.go || die
}

src_compile() {
	go build -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
	go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	dobin "${WORKDIR}/bin/${PN}"
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
