# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="~amd64"
EGO_PN=github.com/google/mtail
EGIT_COMMIT=a780a6342bd70a8fb8ffe187ef988d5417d43a96
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/spf13/afero/archive/06b7e5f50606ecd49148a01a6008942d9b669217.tar.gz -> afero-06b7e5f50606ecd49148a01a6008942d9b669217.tar.gz
	https://github.com/golang/glog/archive/23def4e6c14b4da8ac2ed8007337bc5eb5007998.tar.gz -> go-glog-23def4e6c14b4da8ac2ed8007337bc5eb5007998.tar.gz
	https://github.com/fsnotify/fsnotify/archive/v1.4.2.tar.gz -> go-fsnotify-1.4.2.tar.gz
	https://github.com/golang/tools/archive/76b6c242fbd3fa734fbfe26a653f14fd495cb03a.tar.gz -> go-tools-76b6c242fbd3fa734fbfe26a653f14fd495cb03a.tar.gz
	https://github.com/golang/sys/archive/30237cf4eefd639b184d1f2cb77a581ea0be8947.tar.gz -> go-sys-30237cf4eefd639b184d1f2cb77a581ea0be8947.tar.gz
	https://github.com/golang/text/archive/b01949dc0793a9af5e4cb3fce4d42999e76e8ca1.tar.gz -> go-text-b01949dc0793a9af5e4cb3fce4d42999e76e8ca1.tar.gz
	test? (
		https://github.com/kylelemons/godebug/archive/d99083b96f422f8fd5a93bc02040acec769e178f.tar.gz -> godebug-d99083b96f422f8fd5a93bc02040acec769e178f.tar.gz
	)"
DESCRIPTION="A tool for extracting metrics from application logs"
HOMEPAGE="https://${EGO_PN}/"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
DEPEND=">=dev-lang/go-1.6:="
RDEPEND="!app-misc/mtail"

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
		github.com/fsnotify/fsnotify)
			echo "gopkg.in/fsnotify.v1|fsnotify-*"
			;;
		github.com/golang/glog)
			echo "${uri}|${uri##*/}-*"
			;;
		github.com/golang/*)
			echo "golang.org/x/${uri##*/}|${uri##*/}-*"
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

src_prepare() {
	default
	sed '/^[[:space:]]*go get .*/d' -i "${S}/src/${EGO_PN}/Makefile" || die
}

src_compile() {
	export GOPATH="${S}"
	go install -v -work -x ${EGO_BUILD_FLAGS} "golang.org/x/tools/cmd/goyacc" || die
	PATH=${S}/bin:${PATH} emake -C "${S}/src/${EGO_PN}"
}

src_test() {
	cd "${S}/src/${EGO_PN}" || die
	default
}

src_install() {
	dobin bin/mtail
	dodoc "${S}/src/${EGO_PN}/"{CONTRIBUTING.md,README.md,TODO}
}
