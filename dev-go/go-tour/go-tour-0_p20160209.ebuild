# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EGO_PN="golang.org/x/tour/..."

EGIT_COMMIT="6b2e5b35ce8ed092eaedc3d2a2294373a639f122"
ARCHIVE_URI="https://github.com/golang/tour/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
inherit golang-vcs-snapshot golang-build

DESCRIPTION="A Tour of Go"
HOMEPAGE="https://tour.golang.org"
SRC_URI="${ARCHIVE_URI}"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-tools:="

src_compile() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	rm -rf "${T}/goroot/src/${EGO_PN%/*}" || die
	GOROOT="${T}/goroot" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go build -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	[[ -x $(find "${T}" -name a.out) ]] || die "a.out not found"
}

src_install() {
	GOROOT="${T}/goroot" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	exeinto "$(go env GOTOOLDIR)"
	newexe bin/gotour tour
	insinto "$(go env GOROOT)"
	doins -r src
}
