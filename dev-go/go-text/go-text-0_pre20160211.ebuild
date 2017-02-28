# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGO_PN=golang.org/x/text/...
EGO_SRC=golang.org/x/text

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="07b9a78963006a15c538ec5175243979025fa7a8"
	SRC_URI="https://github.com/golang/text/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go text processing support"
HOMEPAGE="https://godoc.org/golang.org/x/text"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=""
RDEPEND=""

src_compile() {
	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	rm -rf "${T}/goroot/src/${EGO_SRC}" || die
	rm -rf "${T}/goroot/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" || die
	export GOROOT="${T}/goroot"
	golang-build_src_compile
}

src_install() {
	golang-build_src_install
	export -n GOROOT
	exeopts -m0755 -p # preserve timestamps for bug 551486
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
}

src_test() {
	# omit $(get_golibdir_gopath) from GOPATH:
	#package golang.org/x/text/display (test)
	#	imports golang.org/x/text/internal/testtext: use of internal package not allowed
	#FAIL	golang.org/x/text/display [setup failed]
	GOPATH="${WORKDIR}/${P}" go test -v -work -x "${EGO_PN}" || die
}
