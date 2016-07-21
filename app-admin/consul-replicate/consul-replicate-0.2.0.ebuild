# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit golang-base

KEYWORDS="~amd64"
DESCRIPTION="Consul cross-DC KV replication daemon"
EGO_PN="github.com/hashicorp/${PN}/..."
HOMEPAGE="http://${EGO_PN%/*}"
LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

DEPEND=">=dev-lang/go-1.4:="
RDEPEND=""

SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/hashicorp/consul-template/archive/v0.8.0.tar.gz -> consul-template-0.8.0.tar.gz
	https://github.com/fatih/structs/archive/a924a2250d1033753512e95dce41dca3fd793ad9.tar.gz -> structs-a924a2250d1033753512e95dce41dca3fd793ad9.tar.gz
	https://github.com/hashicorp/consul/archive/v0.6.3.tar.gz -> consul-0.6.3.tar.gz
	https://github.com/hashicorp/errwrap/archive/7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz -> errwrap-7554cd9344cec97297fa6649b055a8c98c2a1e55.tar.gz
	https://github.com/hashicorp/go-cleanhttp/archive/ce617e79981a8fff618bb643d155133a8f38db96.tar.gz -> go-cleanhttp-ce617e79981a8fff618bb643d155133a8f38db96.tar.gz
	https://github.com/hashicorp/go-multierror/archive/d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5.tar.gz -> go-multierror-d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5.tar.gz
	https://github.com/hashicorp/go-syslog/archive/42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz -> go-syslog-42a2b573b664dbf281bd48c3cc12c086b17a39ba.tar.gz
	https://github.com/hashicorp/hcl/archive/578dd9746824a54637686b51a41bad457a56bcef.tar.gz -> hcl-578dd9746824a54637686b51a41bad457a56bcef.tar.gz
	https://github.com/hashicorp/logutils/archive/0dc08b1671f34c4250ce212759ebd880f743d883.tar.gz -> logutils-0dc08b1671f34c4250ce212759ebd880f743d883.tar.gz
	https://github.com/hashicorp/serf/archive/64d10e9428bd70dbcd831ad087573b66731c014b.tar.gz -> serf-64d10e9428bd70dbcd831ad087573b66731c014b.tar.gz
	https://github.com/mitchellh/mapstructure/archive/281073eb9eb092240d33ef253c404f1cca550309.tar.gz -> mapstructure-281073eb9eb092240d33ef253c404f1cca550309.tar.gz"

STRIP_MASK="*.a"
S="${WORKDIR}/src/${EGO_PN%/*}"

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
	export GOPATH=${WORKDIR}:$(get_golibdir_gopath)
}

src_prepare() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	export GOROOT="${WORKDIR}/goroot"
	cp -sR "${EPREFIX}"/usr/lib/go "${GOROOT}" || die
	rm -rf "${GOROOT}"/{src,pkg/$(go env GOOS)_$(go env GOARCH)}/"${EGO_PN%/*}" || die

	# Prune conflicting libraries from GOROOT
	while read -r -d '' x; do
		x=${x#${WORKDIR}/src}
		rm -rf "${GOROOT}/src/${x}" "${GOROOT}/pkg/$(go env GOOS)_$(go env GOARCH)/${x}"{,.a} || die
	done < <(find "${WORKDIR}/src" -maxdepth 3 -mindepth 3 -type d -print0)

	sed -e 's:TestParseConfig_parseFileError(:_\0:' -i config_test.go || die
}

src_compile() {
	go build -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
	go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	dobin "${WORKDIR}/bin/${PN}"
	dodoc CHANGELOG.md README.md
}
