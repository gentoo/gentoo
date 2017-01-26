# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit systemd user

KEYWORDS="~amd64"
DESCRIPTION="An etcd backed network fabric for containers"
EGO_PN="github.com/coreos/flannel/..."
HOMEPAGE="https://${EGO_PN%/*}"
SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/golang/tools/archive/ee8cb08bfe4453a27a4bd7c86a917800d339c5ac.tar.gz -> go-tools-0_pre20160220.tar.gz
	https://github.com/golang/crypto/archive/b2fa06b6af4b7c9bfeb8569ab7b17f04550717bf.tar.gz -> go-crypto-b2fa06b6af4b7c9bfeb8569ab7b17f04550717bf.tar.gz
	https://github.com/golang/text/archive/a8b38433e35b65ba247bb267317037dee1b70cea.tar.gz -> go-text-a8b38433e35b65ba247bb267317037dee1b70cea.tar.gz
	https://github.com/gucumber/gucumber/archive/71608e2f6e76fd4da5b09a376aeec7a5c0b5edbc.tar.gz -> gucumber-71608e2f6e76fd4da5b09a376aeec7a5c0b5edbc.tar.gz
	https://github.com/shiena/ansicolor/archive/a422bbe96644373c5753384a59d678f7d261ff10.tar.gz -> ansicolor-a422bbe96644373c5753384a59d678f7d261ff10.tar.gz
	https://github.com/stretchr/testify/archive/v1.1.4.tar.gz -> stretchr-testify-1.1.4.tar.gz
	https://github.com/boltdb/bolt/archive/v1.3.0.tar.gz -> bolt-1.3.0.tar.gz
	https://github.com/coreos/go-semver/archive/v0.2.0.tar.gz -> go-semver-0.2.0.tar.gz
	https://github.com/coreos/go-systemd/archive/v13.tar.gz -> go-systemd-13.tar.gz
	https://github.com/gogo/protobuf/archive/v0.3.tar.gz -> gogo-protobuf-0.3.tar.gz
	https://github.com/google/btree/archive/925471ac9e2131377a91e1595defec898166fe49.tar.gz -> google-btree-925471ac9e2131377a91e1595defec898166fe49.tar.gz
	https://github.com/prometheus/client_golang/archive/v0.8.0.tar.gz -> prometheus-client_golang-0.8.0.tar.gz
	https://github.com/prometheus/client_model/archive/fa8ad6fec33561be4280a8f0514318c79d7f6cb6.tar.gz -> prometheus-client_model-fa8ad6fec33561be4280a8f0514318c79d7f6cb6.tar.gz
	https://github.com/prometheus/common/archive/85637ea67b04b5c3bb25e671dacded2977f8f9f6.tar.gz -> prometheus-common-85637ea67b04b5c3bb25e671dacded2977f8f9f6.tar.gz
	https://github.com/prometheus/procfs/archive/abf152e5f3e97f2fafac028d2cc06c1feb87ffa5.tar.gz -> prometheus-procfs-abf152e5f3e97f2fafac028d2cc06c1feb87ffa5.tar.gz
	https://github.com/beorn7/perks/archive/4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9.tar.gz -> beorn7-perks-4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9.tar.gz
	https://github.com/matttproud/golang_protobuf_extensions/archive/v1.0.0.tar.gz -> golang_protobuf_extensions-1.0.0.tar.gz
	https://github.com/xiang90/probing/archive/07dd2e8dfe18522e9c447ba95f2fe95262f63bb2.tar.gz -> probing-07dd2e8dfe18522e9c447ba95f2fe95262f63bb2.tar.gz
	https://github.com/bgentry/speakeasy/archive/675b82c74c0ed12283ee81ba8a534c8982c07b85.tar.gz -> speakeasy-675b82c74c0ed12283ee81ba8a534c8982c07b85.tar.gz
	https://github.com/grpc/grpc-go/archive/v1.0.3.tar.gz -> grpc-go-1.0.3.tar.gz
	https://github.com/urfave/cli/archive/v1.18.1.tar.gz -> urfave-cli-1.18.1.tar.gz
	https://github.com/godbus/dbus/archive/v4.0.0.tar.gz -> godbus-4.0.0.tar.gz
	https://github.com/go-yaml/yaml/archive/9f9df34309c04878acc86042b16630b0f696e1de.tar.gz -> go-yaml-v1-9f9df34309c04878acc86042b16630b0f696e1de.tar.gz
"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/go-1.6:="
RDEPEND=""

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
	uri=${uri%/archive/*}
	case ${uri} in
		*/golang/crypto|*/golang/net|*/golang/oauth2|*/golang/text|*/golang/tools)
			echo ${uri/github.com\/golang/golang.org\/x}
			;;
		github.com/grpc/grpc-go)
			echo google.golang.org/grpc
			;;
		github.com/GoogleCloudPlatform/google-cloud-go)
			echo "google.golang.org/cloud|gcloud-golang"
			;;
		github.com/go-yaml/yaml)
			echo "gopkg.in/yaml.v1|yaml"
			;;
		*)
			echo ${uri}
			;;
	esac
}

unpack_go_packages() {
	local go_package x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			x=${go_package##*|}
			go_package=${go_package%|*}
			mkdir -p src/${go_package%/*}
			[[ ${x} == ${go_package} ]] && x=${go_package##*/}
			mv ${x}-* src/${go_package} || die
		fi
	done
}

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	unpack_go_packages
}

src_prepare() {
	eapply_user
	grep -rlZ "github\\.com/lsegal/gucumber" "${S}" | \
		xargs -0 sed -e "s:github\\.com/lsegal/gucumber:github\\.com/gucumber/gucumber:g" -i || die
	grep -rlZ "github\\.com/codegangsta/cli" "${S}" | \
		xargs -0 sed -e "s:github\\.com/codegangsta/cli:github\\.com/urfave/cli:g" -i || die
	local x
	while read x; do
		x=${x#${S}/src/${EGO_PN%/*}/vendor/}
		[[ -d ${S}/src/${x} ]] && continue
		ln -s "${S}/src/${EGO_PN%/*}/vendor/${x}" "${S}/src/${x}" || die
	done < <(find "${S}/src/${EGO_PN%/*}/vendor" -type d -mindepth 1 -maxdepth 3)
	sed -e "s:^var Version =.*:var Version = \"${PV}\":" \
		-i "${S}/src/${EGO_PN%/*}/version/version.go" || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	[[ -x bin/${PN} ]] || die
}

src_test() {
	GOPATH="${WORKDIR}/${P}" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	newbin "${S}/bin/${PN}" ${PN}d
	cd "${S}/src/${EGO_PN%/*}" || die
	exeinto /usr/libexec/flannel
	doexe dist/mk-docker-opts.sh
	insinto /etc/systemd/system/docker.service.d
	newins "${FILESDIR}/flannel-docker.conf" flannel.conf
	systemd_newtmpfilesd "${FILESDIR}/flannel.tmpfilesd" flannel.conf
	systemd_dounit "${FILESDIR}/flanneld.service"
	dodoc README.md
}
