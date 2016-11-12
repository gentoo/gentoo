# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KEYWORDS="~amd64"
EGO_PN="github.com/outbrain/zookeepercli/..."
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
https://github.com/outbrain/golib/archive/2418949ac30d9933e7412ccce41f1aa2ae8d5ae8.tar.gz -> golib-2418949ac30d9933e7412ccce41f1aa2ae8d5ae8.tar.gz
https://github.com/samuel/go-zookeeper/archive/218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f.tar.gz -> go-zookeeper-218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f.tar.gz"
DESCRIPTION="Simple, lightweight, dependable CLI for ZooKeeper"
HOMEPAGE="https://${EGO_PN%/*}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

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
			mkdir -p "${S}/src/${go_package%/*}"
			for x in ${go_package##*/}-*; do
				[[ ${x} -ef ${S} ]] && continue
				mv "${x}" "${S}/src/${go_package}" || die
			done
		fi
	done
}

src_unpack() {
	unpack_go_packages
}

src_compile() {
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
}
