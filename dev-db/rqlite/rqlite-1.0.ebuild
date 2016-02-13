# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit golang-build

KEYWORDS="~amd64"
DESCRIPTION="Replicated SQLite using the Raft consensus protocol "
EGO_PN="github.com/otoolep/rqlite/..."
HOMEPAGE="https://${EGO_PN%/*} http://www.philipotoole.com/replicating-sqlite-using-raft-consensus"
LICENSE="MIT"
SLOT="0/${PVR}"
IUSE=""
RESTRICT="test"
EGIT_COMMIT="v${PV}"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/gorilla/mux/archive/26a6070f849969ba72b72256e9f14cf519751690.tar.gz -> gorilla-mux-26a6070f849969ba72b72256e9f14cf519751690.tar.gz
	https://github.com/gorilla/context/archive/1c83b3eabd45b6d76072b66b746c20815fb2872d.tar.gz -> gorilla-context-1c83b3eabd45b6d76072b66b746c20815fb2872d.tar.gz
	https://github.com/otoolep/raft/archive/75a23dbefaeea0be2869de087c2cd3379e84c424.tar.gz -> go-raft-75a23dbefaeea0be2869de087c2cd3379e84c424.tar.gz
	https://github.com/golang/protobuf/archive/68c687dc49948540b356a6b47931c9be4fcd0245.tar.gz -> go-protobuf-0_pre20150809.tar.gz
	https://github.com/rcrowley/go-metrics/archive/51425a2415d21afadfd55cd93432c0bc69e9598d.tar.gz -> go-metrics-51425a2415d21afadfd55cd93432c0bc69e9598d.tar.gz
	https://github.com/mattn/go-sqlite3/archive/c5aee9649735e8dadac55eb968ccebd9fa29a881.tar.gz -> go-sqlite3-1.1.0_p20160131.tar.gz"

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
			if [[ ${x%.tar.gz} -ef ${S} ]]; then
				mv "${S}"{,_} || die
				mkdir -p "${S}/src/${go_package%/*}" || die
				mv "${S}"_ "${S}/src/${go_package}" || die || die
			else
				mkdir -p "${S}/src/${go_package%/*}" || die
				mv "${go_package##*/}"-* "${S}/src/${go_package}" || die
			fi
		fi
	done
}

src_unpack() {
	unpack_go_packages
}

golang_install_pkgs() {
	dobin bin/${PN}
	insinto $(dirname "${EPREFIX}$(get_golibdir)/src/${EGO_PN%/*}")
	doins -r "${S}"/src/${EGO_PN%/*}
	insinto $(dirname "${EPREFIX}$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}
	dodoc "${S}/src/${EGO_PN%/*}/README.md"
}
