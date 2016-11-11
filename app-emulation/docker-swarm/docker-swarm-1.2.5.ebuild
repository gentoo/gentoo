# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KEYWORDS="~amd64"
EGO_PN=github.com/docker/${PN##*-}/...
SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/gogo/protobuf/archive/v0.3.tar.gz -> gogo-protobuf-0.3.tar.gz
	https://github.com/gemnasium/logrus-airbrake-hook/archive/v2.1.1.tar.gz -> logrus-airbrake-hook-2.1.1.tar.gz
	https://github.com/airbrake/gobrake/archive/v2.0.8.tar.gz -> gobrake-2.0.8.tar.gz
	https://github.com/Sirupsen/logrus/archive/v0.11.0.tar.gz -> logrus-0.11.0.tar.gz"
DESCRIPTION="A Docker-native clustering system"
HOMEPAGE="https://docs.docker.com/${PN##*-}/"
LICENSE="Apache-2.0 CC-BY-SA-4.0"
SLOT="0"
IUSE=""
RESTRICT="test"
DEPEND=">=dev-lang/go-1.6:=
	!!<app-admin/consul-0.6.3-r1"
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
			echo "${EGO_PN%/*}|swarm-*"
			;;
		github.com/gemnasium/logrus-airbrake-hook)
			echo "gopkg.in/gemnasium/logrus-airbrake-hook.v2|logrus-airbrake-hook-*"
			;;
		github.com/airbrake/gobrake)
			echo "gopkg.in/airbrake/gobrake.v2|gobrake-*"
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
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	[[ -x ${S}/bin/${PN#docker-} ]] || die
}

src_install() {
	dobin "${S}/bin/${PN#docker-}"
	dosym swarm /usr/bin/docker-swarm
	cd "${S}/src/${EGO_PN%/*}" || die
	dodoc CHANGELOG.md CONTRIBUTING.md logo.png README.md ROADMAP.md
}
