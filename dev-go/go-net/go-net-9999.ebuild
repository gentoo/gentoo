# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_SRC=golang.org/x/net
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~x86"
	EGIT_COMMIT="aaf60122140d3fcf75376d319f0554393160eb50"
	SRC_URI="https://github.com/golang/net/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go supplementary network libraries"
HOMEPAGE="https://godoc.org/golang.org/x/net"
LICENSE="BSD"
SLOT="0/${PVR}"
IUSE=""
DEPEND=">=dev-go/go-crypto-0_pre20180816:=
	>=dev-go/go-sys-0_pre20180816:=
	>=dev-go/go-text-0.3.0:="
RDEPEND=""

src_prepare() {
	default
	sed -e 's:TestDiag(:_\0:' \
		-e 's:TestConcurrentNonPrivilegedListenPacket(:_\0:' \
		-i src/${EGO_SRC}/icmp/diag_test.go || die
	sed -e 's:TestConcurrentNonPrivilegedListenPacket(:_\0:' \
		-i src/${EGO_SRC}/icmp/diag_test.go || die
	sed -e 's:TestMultipartMessageBodyLen(:_\0:' \
		-i src/${EGO_SRC}/icmp/multipart_test.go || die
}

src_compile() {
	local x
	mkdir -p "${T}/golibdir/src/golang.org/x" || die
	for x in sys text crypto; do
		ln -s "$(get_golibdir_gopath)/src/golang.org/x/${x}" "${T}/golibdir/src/golang.org/x/${x}" || die
	done
	env GOPATH="${S}:${T}/golibdir" GOBIN="${S}/bin" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_test() {
	GOPATH="${S}:${T}/golibdir" GOBIN="${S}/bin" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	rm -rf "${S}/src/${EGO_SRC}/.git"* || die
	golang_install_pkgs
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*
}
