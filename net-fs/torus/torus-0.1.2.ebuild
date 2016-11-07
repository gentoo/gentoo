# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN="github.com/coreos/${PN}/..."
SRC_URI="https://${EGO_PN}/releases/download/v${PV}/${PN}_v${PV}_src.tar.gz -> ${P}.tar.gz
	https://github.com/Masterminds/glide/archive/0.10.2.tar.gz -> glide-0.10.2.tar.gz
	test? ( https://github.com/gogo/protobuf/archive/v0.3.tar.gz -> gogo-protobuf-0.3.tar.gz )"

DESCRIPTION="A distributed storage system coordinated through etcd"
HOMEPAGE="https://${EGO_PN%/*}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

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
		${EGO_PN%/*}*)
			echo "${EGO_PN%/*}|${PN}_*"
			;;
		*)
			echo "${uri}|${uri##*/}-*"
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
			x=${go_package#*|}
			go_package=${go_package%|*}
			mkdir -p src/${go_package%/*}
			mv ${x} src/${go_package} || die
		fi
	done
}

src_unpack() {
	mkdir "${S}" || die
	cd "${S}" || die
	unpack_go_packages
}

src_compile() {
	GOPATH="${S}" go install -v -work -x github.com/Masterminds/glide/... || die
	mkdir -p "${S}/src/${EGO_PN%/*}/tools" || die
	mv "${S}/bin/glide" "${S}/src/${EGO_PN%/*}/tools/glide" || die
	GOPATH="${S}" \
		emake -C "${S}/src/${EGO_PN%/*}" VERSION=v${PV} build
}

src_test() {
	GOPATH="${S}" \
		emake -C "${S}/src/${EGO_PN%/*}" VERSION=v${PV} test
}

src_install() {
	cd "${S}/src/${EGO_PN%/*}"|| die
	dobin bin/${PN}*
	dodoc README.md
	use doc && dodoc -r Documentation
}
