# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base systemd user

GO_PN="github.com/hashicorp/consul"

DESCRIPTION="A tool for service discovery, monitoring and configuration"
HOMEPAGE="http://www.consul.io"
SRC_URI="
	https://github.com/hashicorp/consul/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/armon/circbuf/archive/bbbad097214e2918d8543d5201d12bfd7bca254d.tar.gz -> circbuf-bbbad097214e2918d8543d5201d12bfd7bca254d.tar.gz
	https://github.com/armon/go-metrics/archive/345426c77237ece5dab0e1605c3e4b35c3f54757.tar.gz -> go-metrics-345426c77237ece5dab0e1605c3e4b35c3f54757.tar.gz
	https://github.com/armon/go-radix/archive/4239b77079c7b5d1243b7b4736304ce8ddb6f0f2.tar.gz -> go-radix-4239b77079c7b5d1243b7b4736304ce8ddb6f0f2.tar.gz
	https://github.com/armon/gomdb/archive/151f2e08ef45cb0e57d694b2562f351955dff572.tar.gz -> gomdb-151f2e08ef45cb0e57d694b2562f351955dff572.tar.gz
	https://github.com/beorn7/perks/archive/3ac7bf7a47d159a033b107610db8a1b6575507a4.tar.gz -> perks-3ac7bf7a47d159a033b107610db8a1b6575507a4.tar.gz
	https://github.com/boltdb/bolt/archive/ee4a0888a9abe7eefe5a0992ca4cb06864839873.tar.gz -> bolt-ee4a0888a9abe7eefe5a0992ca4cb06864839873.tar.gz
	https://github.com/bgentry/speakeasy/archive/36e9cfdd690967f4f690c6edcc9ffacd006014a0.tar.gz -> speakeasy-36e9cfdd690967f4f690c6edcc9ffacd006014a0.tar.gz
	https://github.com/DataDog/datadog-go/archive/b050cd8f4d7c394545fd7d966c8e2909ce89d552.tar.gz -> datadog-go-b050cd8f4d7c394545fd7d966c8e2909ce89d552.tar.gz
	https://github.com/fsouza/go-dockerclient/archive/9b6c9720043b74304a6dd07a2a901d16e7bf3d3d.tar.gz -> go-dockerclient-9b6c9720043b74304a6dd07a2a901d16e7bf3d3d.tar.gz
	https://github.com/elazarl/go-bindata-assetfs/archive/57eb5e1fc594ad4b0b1dbea7b286d299e0cb43c2.tar.gz -> go-bindata-assetfs-57eb5e1fc594ad4b0b1dbea7b286d299e0cb43c2.tar.gz
	https://github.com/golang/protobuf/archive/127091107ff5f822298f1faa7487ffcf578adcf6.tar.gz -> go-protobuf-0_pre20160216.tar.gz
	https://github.com/hashicorp/consul-migrate/archive/v0.1.0.tar.gz -> consul-migrate-0.1.0.tar.gz
	https://github.com/hashicorp/errwrap/archive/7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz -> errwrap-7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz
	https://github.com/hashicorp/go-checkpoint/archive/e4b2dc34c0f698ee04750bf2035d8b9384233e1b.tar.gz -> go-checkpoint-e4b2dc34c0f698ee04750bf2035d8b9384233e1b.tar.gz
	https://github.com/hashicorp/go-cleanhttp/archive/875fb671b3ddc66f8e2f0acc33829c8cb989a38d.tar.gz -> go-cleanhttp-875fb671b3ddc66f8e2f0acc33829c8cb989a38d.tar.gz
	https://github.com/hashicorp/go-immutable-radix/archive/8e8ed81f8f0bf1bdd829593fdd5c29922c1ea990.tar.gz -> go-immutable-radix-8e8ed81f8f0bf1bdd829593fdd5c29922c1ea990.tar.gz
	https://github.com/hashicorp/go-memdb/archive/98f52f52d7a476958fa9da671354d270c50661a7.tar.gz -> go-memdb-98f52f52d7a476958fa9da671354d270c50661a7.tar.gz
	https://github.com/hashicorp/go-msgpack/archive/fa3f63826f7c23912c15263591e65d54d080b458.tar.gz -> go-msgpack-fa3f63826f7c23912c15263591e65d54d080b458.tar.gz
	https://github.com/hashicorp/go-multierror/archive/d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5.tar.gz -> go-multierror-d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5.tar.gz
	https://github.com/hashicorp/go-syslog/archive/42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz -> go-syslog-42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz
	https://github.com/hashicorp/go-reap/archive/2d85522212dcf5a84c6b357094f5c44710441912.tar.gz -> go-reap-2d85522212dcf5a84c6b357094f5c44710441912.tar.gz
	https://github.com/hashicorp/golang-lru/archive/5c7531c003d8bf158b0fe5063649a2f41a822146.tar.gz -> golang-lru-5c7531c003d8bf158b0fe5063649a2f41a822146.tar.gz
	https://github.com/hashicorp/hcl/archive/578dd9746824a54637686b51a41bad457a56bcef.tar.gz -> hcl-578dd9746824a54637686b51a41bad457a56bcef.tar.gz
	https://github.com/hashicorp/logutils/archive/0dc08b1671f34c4250ce212759ebd880f743d883.tar.gz -> logutils-0dc08b1671f34c4250ce212759ebd880f743d883.tar.gz
	https://github.com/hashicorp/memberlist/archive/cef12ad58224d55cf26caa9e3d239c2fcb3432a2.tar.gz -> memberlist-cef12ad58224d55cf26caa9e3d239c2fcb3432a2.tar.gz
	https://github.com/hashicorp/net-rpc-msgpackrpc/archive/a14192a58a694c123d8fe5481d4a4727d6ae82f3.tar.gz -> net-rpc-msgpackrpc-a14192a58a694c123d8fe5481d4a4727d6ae82f3.tar.gz
	https://github.com/hashicorp/raft/archive/057b893fd996696719e98b6c44649ea14968c811.tar.gz -> raft-057b893fd996696719e98b6c44649ea14968c811.tar.gz
	https://github.com/hashicorp/raft-boltdb/archive/d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee.tar.gz -> raft-boltdb-d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee.tar.gz
	https://github.com/hashicorp/raft-mdb/archive/55f29473b9e604b3678b93a8433a6cf089e70f76.tar.gz -> raft-mdb-55f29473b9e604b3678b93a8433a6cf089e70f76.tar.gz
	https://github.com/hashicorp/scada-client/archive/84989fd23ad4cc0e7ad44d6a871fd793eb9beb0a.tar.gz -> scada-client-84989fd23ad4cc0e7ad44d6a871fd793eb9beb0a.tar.gz
	https://github.com/hashicorp/serf/archive/e4ec8cc423bbe20d26584b96efbeb9102e16d05f.tar.gz -> serf-e4ec8cc423bbe20d26584b96efbeb9102e16d05f.tar.gz
	https://github.com/hashicorp/yamux/archive/df949784da9ed028ee76df44652e42d37a09d7e4.tar.gz -> yamux-df949784da9ed028ee76df44652e42d37a09d7e4.tar.gz
	https://github.com/inconshreveable/muxado/archive/f693c7e88ba316d1a0ae3e205e22a01aa3ec2848.tar.gz -> muxado-f693c7e88ba316d1a0ae3e205e22a01aa3ec2848.tar.gz
	https://github.com/jteeuwen/go-bindata/archive/a0ff2567cfb70903282db057e799fd826784d41d.tar.gz -> go-bindata-a0ff2567cfb70903282db057e799fd826784d41d.tar.gz
	https://github.com/mattn/go-isatty/archive/56b76bdf51f7708750eac80fa38b952bb9f32639.tar.gz -> go-isatty-56b76bdf51f7708750eac80fa38b952bb9f32639.tar.gz
	https://github.com/matttproud/golang_protobuf_extensions/archive/d0c3fe89de86839aecf2e0579c40ba3bb336a453.tar.gz -> golang_protobuf_extensions-d0c3fe89de86839aecf2e0579c40ba3bb336a453.tar.gz
	https://github.com/miekg/dns/archive/75e6e86cc601825c5dbcd4e0c209eab180997cd7.tar.gz -> dns-75e6e86cc601825c5dbcd4e0c209eab180997cd7.tar.gz
	https://github.com/mitchellh/cli/archive/cb6853d606ea4a12a15ac83cc43503df99fd28fb.tar.gz -> cli-cb6853d606ea4a12a15ac83cc43503df99fd28fb.tar.gz
	https://github.com/mitchellh/gox/archive/39862d88e853ecc97f45e91c1cdcb1b312c51eaa.tar.gz -> gox-39862d88e853ecc97f45e91c1cdcb1b312c51eaa.tar.gz
	https://github.com/mitchellh/iochan/archive/87b45ffd0e9581375c491fef3d32130bb15c5bd7.tar.gz -> iochan-87b45ffd0e9581375c491fef3d32130bb15c5bd7.tar.gz
	https://github.com/mitchellh/mapstructure/archive/281073eb9eb092240d33ef253c404f1cca550309.tar.gz -> mapstructure-281073eb9eb092240d33ef253c404f1cca550309.tar.gz
	https://github.com/prometheus/client_golang/archive/90c15b5efa0dc32a7d259234e02ac9a99e6d3b82.tar.gz -> client_golang-90c15b5efa0dc32a7d259234e02ac9a99e6d3b82.tar.gz
	https://github.com/prometheus/client_model/archive/fa8ad6fec33561be4280a8f0514318c79d7f6cb6.tar.gz -> client_model-fa8ad6fec33561be4280a8f0514318c79d7f6cb6.tar.gz
	https://github.com/prometheus/common/archive/40456948a47496dc22168e6af39297a2f8fbf38c.tar.gz -> common-40456948a47496dc22168e6af39297a2f8fbf38c.tar.gz
	https://github.com/prometheus/procfs/archive/406e5b7bfd8201a36e2bb5f7bdae0b03380c2ce8.tar.gz -> procfs-406e5b7bfd8201a36e2bb5f7bdae0b03380c2ce8.tar.gz
	https://github.com/ryanuber/columnize/archive/983d3a5fab1bf04d1b412465d2d9f8430e2e917e.tar.gz -> columnize-983d3a5fab1bf04d1b412465d2d9f8430e2e917e.tar.gz"

SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="test"

DEPEND="
	app-arch/zip
	>=dev-lang/go-1.5:=
	dev-go/go-crypto:=
	dev-go/go-sys:=
	>=dev-go/go-tools-0_pre20160121"
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
			mkdir -p src/${go_package%/*}
			mv ${go_package##*/}-* src/${go_package} || die
		fi
	done
}

src_unpack() {
	unpack_go_packages
	# Create a writable GOROOT in order to avoid sandbox violations
	# or other interference from installed instances.
	export GOPATH="${WORKDIR}:$(get_golibdir_gopath)" GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	while read -r path; do
		rm -rf "${GOROOT}/src/${path#${WORKDIR}/src}" \
		"${GOROOT}/pkg/$(go env GOOS)_$(go env GOARCH)/${path#${WORKDIR}/src}" || die
	done < <(find "${WORKDIR}"/src -maxdepth 3 -mindepth 3 -type d)
}

src_prepare() {
	# Avoid the need to have a git checkout
	sed -e 's:^GIT.*::' \
		-e 's:-X main.GitCommit.*:" \\:' \
		-e 's:$GOPATH/bin/::' \
		-i scripts/build.sh || die

	# go install golang.org/x/tools/cmd/stringer: mkdir /usr/lib/go-gentoo/bin/: permission denied
	sed -e 's:go get -u -v $(GOTOOLS)::' \
		-i GNUmakefile || die

	# Disable tests that fail under network-sandbox
	sed -e 's:TestServer_StartStop:_TestServer_StartStop:' \
		-i consul/server_test.go || die
	sed -e 's:TestRetryJoin(:_TestRetryJoin(:' \
		-i command/agent/command_test.go || die
}

src_compile() {
	export GO15VENDOREXPERIMENT=1
	go install -v -work -x ${EGO_BUILD_FLAGS} "github.com/mitchellh/gox/..." || die
	go install -v -work -x ${EGO_BUILD_FLAGS} "${GO_PN}/..." || die
	PATH=${PATH}:${WORKDIR}/bin XC_ARCH=$(go env GOARCH) XC_OS=$(go env GOOS) emake
}

src_install() {
	local x

	dobin "${WORKDIR}/bin/${PN}"
	rm -rf bin || die

	keepdir /etc/consul.d
	insinto /etc/consul.d
	doins "${FILESDIR}/"*.json.example
	rm "${ED}etc/consul.d/ui-dir.json.example" || die

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners consul:consul "${x}"
	done

	newinitd "${FILESDIR}/consul.initd" "${PN}"
	newconfd "${FILESDIR}/consul.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/consul.service"

	find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type f -delete || die
	rm -rf "${WORKDIR}"/{src,pkg/$(go env GOOS)_$(go env GOARCH)}/${GO_PN}/vendor

	while read -r -d '' x; do
		x=${x#${WORKDIR}/src}
		[[ -d ${WORKDIR}/pkg/$(go env GOOS)_$(go env GOARCH)/${x} ||
			-f ${WORKDIR}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}.a ]] && continue
		rm -rf "${WORKDIR}"/src/${x}
	done < <(find "${WORKDIR}"/src/${GO_PN} -mindepth 1 -maxdepth 1 -type d -print0)
	insopts -m0644 -p # preserve timestamps for bug 551486
	insinto "$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${GO_PN%/*}"
	doins -r "${WORKDIR}"/pkg/$(go env GOOS)_$(go env GOARCH)/${GO_PN}
	insinto "$(get_golibdir)/src/${GO_PN%/*}"
	doins -r "${WORKDIR}"/src/${GO_PN}
}
