# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit golang-build

KEYWORDS="~amd64"
DESCRIPTION="A tool for helping develop with beego app framework"
EGO_PN="github.com/beego/bee/..."
EGIT_COMMIT="1566ca7da16102eab17a81346a1bc223642bc183"
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/go-sql-driver/mysql/archive/267b128680c46286b9ca13475c3cca5de8f79bd7.tar.gz -> go-mysql-267b128680c46286b9ca13475c3cca5de8f79bd7.tar.gz
	https://github.com/howeyc/fsnotify/archive/f0c08ee9c60704c1879025f2ae0ff3e000082c13.tar.gz -> fsnotify-f0c08ee9c60704c1879025f2ae0ff3e000082c13.tar.gz
	https://github.com/lib/pq/archive/f59175c2986495ff94109dee3835c504a96c3e81.tar.gz -> pq-f59175c2986495ff94109dee3835c504a96c3e81.tar.gz
	https://github.com/smartystreets/goconvey/archive/bf58a9a1291224109919756b4dcc469c670cc7e4.tar.gz -> goconvey-bf58a9a1291224109919756b4dcc469c670cc7e4.tar.gz
	https://github.com/smartystreets/assertions/archive/287b4346dc4e71a038c346375a9d572453bc469b.tar.gz -> assertions-287b4346dc4e71a038c346375a9d572453bc469b.tar.gz
	https://github.com/jtolds/gls/archive/8ddce2a84170772b95dd5d576c48d517b22cac63.tar.gz -> gls-8ddce2a84170772b95dd5d576c48d517b22cac63.tar.gz"

HOMEPAGE="https://${EGO_PN%/*}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
DEPEND="dev-go/beego:="

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

src_install() {
	dobin bee
	dodoc "${S}/src/${EGO_PN%/*}/README.md"
}
