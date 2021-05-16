# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
EGIT_COMMIT=8f38c9a8d074c1943ede6463d78b0d769331dd3e
EGO_PN="golang.org/x/tour"

DESCRIPTION="A Tour of Go"
HOMEPAGE="https://tour.golang.org"

EGO_SUM=(
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a"
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20190312164927-7b79afddac43"
	"golang.org/x/tools v0.0.0-20190312164927-7b79afddac43/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/golang/tour/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

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
