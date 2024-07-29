# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
EGIT_COMMIT=8f38c9a8d074c1943ede6463d78b0d769331dd3e
EGO_PN="golang.org/x/tour"

DESCRIPTION="A Tour of Go"
HOMEPAGE="https://tour.golang.org"
SRC_URI="https://github.com/golang/tour/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="BSD Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
S=${WORKDIR}/${PN#go-}-${EGIT_COMMIT}

src_compile() {
	export GOBIN="${WORKDIR}/bin"
	go install -work ${EGO_BUILD_FLAGS} ./... || die
}

src_install() {
	exeinto "$(go env GOTOOLDIR)"
	doexe "${GOBIN}/tour"

	rm -rf vendor || die
	insinto "$(go env GOROOT)/src/golang.org/x/tour"
	doins -r *
}

src_test() {
	go test -work ./... || die
}
