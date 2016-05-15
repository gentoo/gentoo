# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
fi

inherit golang-build

KEYWORDS=""
DESCRIPTION="Replicated SQLite using the Raft consensus protocol"
EGO_PN="github.com/rqlite/rqlite/..."
HOMEPAGE="https://${EGO_PN%/*} http://www.philipotoole.com/tag/rqlite/"
LICENSE="MIT"
SLOT="0/${PVR}"
IUSE=""
EGIT_REPO_URI="https://github.com/rqlite/rqlite.git"
#EGIT_COMMIT="e3c20964fbdda2e865a5af20667a74fc2c3b5582"
SRC_URI="
	https://github.com/armon/go-metrics/archive/345426c77237ece5dab0e1605c3e4b35c3f54757.tar.gz -> go-metrics-345426c77237ece5dab0e1605c3e4b35c3f54757.tar.gz
	https://github.com/boltdb/bolt/archive/ee4a0888a9abe7eefe5a0992ca4cb06864839873.tar.gz -> bolt-ee4a0888a9abe7eefe5a0992ca4cb06864839873.tar.gz
	https://github.com/hashicorp/go-msgpack/archive/fa3f63826f7c23912c15263591e65d54d080b458.tar.gz -> go-msgpack-fa3f63826f7c23912c15263591e65d54d080b458.tar.gz
	https://github.com/hashicorp/raft/archive/057b893fd996696719e98b6c44649ea14968c811.tar.gz -> hashicorp-raft-057b893fd996696719e98b6c44649ea14968c811.tar.gz
	https://github.com/hashicorp/raft-boltdb/archive/d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee.tar.gz -> hashicorp-boltdb-d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee.tar.gz
	https://github.com/mattn/go-sqlite3/archive/10876d7dac65f02064c03d7372a2f1dfb90043fe.tar.gz -> go-sqlite3-1.1.0_p20160307.tar.gz"

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
				for x in "${go_package##*/}"-*; do
					if [[ ! ${x} -ef ${S} ]]; then
						mv "${x}" "${S}/src/${go_package}" || die
					fi
				done
			fi
		fi
	done
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
		mv "${S}"{,_} || die
		mkdir -p "$(dirname "${S}/src/${EGO_PN%/*}")" || die
		mv "${S}_" "${S}/src/${EGO_PN%/*}" || die
	fi
	unpack_go_packages
}

src_compile() {
	# Omit $(get_golibdir_gopath) from GOPATH, in order to avoid
	# interference from installed rqlite sources.
	GOPATH="${WORKDIR}/${P}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_install() {
	golang_install_pkgs
}

golang_install_pkgs() {
	dobin bin/${PN}d
	insinto $(dirname "${EPREFIX}$(get_golibdir)/src/${EGO_PN%/*}")
	rm -rf "${S}"/src/${EGO_PN%/*}/.git*
	doins -r "${S}"/src/${EGO_PN%/*}
	insinto $(dirname "${EPREFIX}$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}{,.a}
	dodoc "${S}/src/${EGO_PN%/*}/"*.md
}
