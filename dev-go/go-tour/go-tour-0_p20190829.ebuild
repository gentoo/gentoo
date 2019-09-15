# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="golang.org/x/tour"

EGO_VENDOR=(
	"golang.org/x/tools 7b79afddac434519a8ca775cc575fddb0d162aab github.com/golang/tools"
	"golang.org/x/net 3b0461eec859c4b73bb64fdc8285971fd33e3938 github.com/golang/net"
)

EGIT_COMMIT="3c9f1af8b2da3b3661a39ee550190917c0cf5208"
ARCHIVE_URI="https://github.com/golang/tour/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
inherit golang-vcs-snapshot golang-build

DESCRIPTION="A Tour of Go"
HOMEPAGE="https://tour.golang.org"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="BSD Apache-2.0 MIT"
SLOT="0"
IUSE=""
S=${WORKDIR}/${P}/src/${EGO_PN}

src_compile() {
	# Create a temporary GOROOT, since otherwise the executable is not
	# built if it happens to be installed already.
	cp -rs "$(go env GOROOT)" "${T}/goroot" || die
	rm -rf "${T}/goroot/"{pkg/tool/$(go env GOOS)_$(go env GOARCH)/tour,src/${EGO_PN}} || die
	export -n GOCACHE XDG_CACHE_HOME #567192
	export GOPATH="${WORKDIR}/${P}" \
		GO111MODULE=on \
		GOFLAGS="-mod=vendor -v -x" \
		GOBIN="${WORKDIR}/${P}/bin"
	GOROOT=${T}/goroot \
		go install -work ${EGO_BUILD_FLAGS} "${EGO_PN}/..." || die
}

src_install() {
	exeinto "$(go env GOTOOLDIR)"
	doexe "${GOBIN}/tour"

	rm -rf vendor || die
	insinto "$(go env GOROOT)"
	doins -r "${WORKDIR}/${P}/src"
}

src_test() {
	go test -work "${EGO_PN}/..." || die
}
