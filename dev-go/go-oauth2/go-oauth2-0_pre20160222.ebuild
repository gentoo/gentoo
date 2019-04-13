# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils golang-base

MY_PN=${PN##*-}
EGO_PN="golang.org/x/${MY_PN}/..."
EGIT_COMMIT="2cd4472c321b6cba78e029d99f0e7fe51032fd21"

DESCRIPTION="Go client implementation for OAuth 2.0 spec"
HOMEPAGE="https://godoc.org/golang.org/x/oauth2"
SRC_URI="
	https://github.com/golang/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/golang/net/archive/b6d7b1396ec874c3b00f6c84cd4301a17c56c8ed.tar.gz -> go-net-0_pre20160216.tar.gz
	https://github.com/GoogleCloudPlatform/gcloud-golang/archive/872c736f496c2ba12786bedbb8325576bbdb33cf.tar.gz -> gcloud-golang-872c736f496c2ba12786bedbb8325576bbdb33cf.tar.gz"

SLOT="0/${PVR}"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-go/go-tools"
RDEPEND=""

EGIT_CHECKOUT_DIR="${S}"

get_archive_go_package() {
	local archive=${1} uri x
	case ${archive} in
		${PN}-*) echo "oauth2-* golang.org/x/oauth2"; return;;
		gcloud-golang-*) echo "gcloud-golang-* google.golang.org/cloud"; return;;
		go-net-*) echo "net-* golang.org/x/net"; return;;
	esac
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	uri=${uri%/archive/*}
	echo "${uri##*/}-* ${uri}"
}

unpack_go_packages() {
	local go_package pattern x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			pattern=${go_package%% *}
			go_package=${go_package##* }
			if [[ ${x%.tar.gz} -ef ${S} ]]; then
				mv "${S}"{,_} || die
				mkdir -p "${S}/src/${go_package%/*}" || die
				mv "${S}"_ "${S}/src/${go_package}" || die || die
			else
				mkdir -p "${S}/src/${go_package%/*}" || die
				for x in ${pattern}; do
					if [[ ! ${x} -ef ${S} ]]; then
						mv "${x}" "${S}/src/${go_package}" || die
					fi
				done
			fi
		fi
	done
}

src_unpack() {
	unpack_go_packages

	# Create a writable GOROOT in order to avoid sandbox violations.
	# Omit $(get_golibdir_gopath) from GOPATH, in order to avoid
	# more sandbox violations (bug 575722).
	GOROOT="${WORKDIR}/goroot" GOPATH="${S}"
	cp -sR "$(go env GOROOT)" "${GOROOT}" || die
	rm -rf "${GOROOT}/src/${EGO_PN%/*}" || die
	export GOROOT GOPATH

	mkdir -p "${GOROOT}/src/google.golang.org" || die
	rm -rf "${GOROOT}/src/google.golang.org"/* || die
	rm -rf "${GOROOT}/pkg/${KERNEL}_${ARCH}/google.golang.org" || die
}

src_compile() {
	GOROOT="${GOROOT}" GOPATH="${GOPATH}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_test() {
	# google/example_test.go imports appengine, introducing a circular dep
	mv src/${EGO_PN%/*}/google/example_test.go{,_} || die
	go test -x -v "${EGO_PN}" || die $?
	mv src/${EGO_PN%/*}/google/example_test.go{_,} || die
}

src_install() {
	golang_install_pkgs
}

golang_install_pkgs() {
	insinto $(dirname "${EPREFIX}$(get_golibdir)/src/${EGO_PN%/*}")
	rm -rf "${S}"/src/${EGO_PN%/*}/.git*
	doins -r "${S}"/src/${EGO_PN%/*}
	insinto $(dirname "${EPREFIX}$(get_golibdir)/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}")
	doins -r "${S}"/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_PN%/*}{,.a}
}
