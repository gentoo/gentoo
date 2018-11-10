# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="golang.org/x/tour/..."

EGIT_COMMIT="d642b9371986f5bb2152547a0d525a57f634c3ef"
ARCHIVE_URI="https://github.com/golang/tour/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
inherit golang-vcs-snapshot golang-build

DESCRIPTION="A Tour of Go"
HOMEPAGE="https://tour.golang.org"
SRC_URI="${ARCHIVE_URI}"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-net:=
	dev-go/go-tools:="

src_compile() {
	local x
	mkdir -p "${T}/golibdir/src/golang.org/x" || die
	for x in net tools; do
		ln -s "$(get_golibdir_gopath)/src/golang.org/x/${x}" "${T}/golibdir/src/golang.org/x/${x}" || die
	done
	GOPATH="${S}:${T}/golibdir" GOBIN="${S}/bin" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}"
	[[ -x bin/gotour ]] || die "gotour not found"
}

src_install() {
	exeinto "$(go env GOTOOLDIR)"
	newexe bin/gotour tour
	insinto "$(go env GOROOT)"
	doins -r src
}

src_test() {
	GOPATH="${S}:${T}/golibdir" GOBIN="${S}/bin" \
		go test -v -work -x "${EGO_PN}" || die
}
