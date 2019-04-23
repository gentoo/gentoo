# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=golang.org/x/sys/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="1c9583448a9c3aa0f9a6a5241bf73c0bd8aafded"
	SRC_URI="https://github.com/golang/sys/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go packages for low-level interaction with the operating system"
HOMEPAGE="https://godoc.org/golang.org/x/sys"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=""
RDEPEND=""

src_compile() {
	GOPATH="${S}" GOBIN="$(go env GOROOT)/bin" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_test() {
	GOPATH="${S}" GOBIN="$(go env GOROOT)/bin" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	rm -rf "${S}/src/${EGO_PN%/...}/.git"* || die
	golang_install_pkgs
}
