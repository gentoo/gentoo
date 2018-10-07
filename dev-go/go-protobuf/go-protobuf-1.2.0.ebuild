# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_SRC="github.com/golang/protobuf"
EGO_PN=${EGO_SRC}/...
EGO_VENDOR=(
	"google.golang.org/genproto af9cb2a35e7f169ec875002c1829c9b315cddc04 github.com/google/go-genproto"
	"golang.org/x/net aaf60122140d3fcf75376d319f0554393160eb50 github.com/golang/net"
	"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Go support for Google's protocol buffers"
HOMEPAGE="https://github.com/golang/protobuf"
SRC_URI="https://${EGO_SRC}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="BSD"
SLOT="0/${PVR}"
KEYWORDS="~amd64"
IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	default
	# golden_test.go:113: golden file differs: deprecated/deprecated.pb.go
	sed -e 's:^\(func \)\(TestGolden\):\1_\2:' \
		-i src/${EGO_SRC}/protoc-gen-go/golden_test.go || die
}

src_compile() {
	env GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}" || die
}

src_test() {
	GOPATH="${S}" \
		go test -v -work -x "${EGO_PN}" || die
}

src_install() {
	rm -rf src/${EGO_SRC}/.git* || die
	golang_install_pkgs
	rm -rf "${D%/}$(get_golibdir_gopath)/src/${EGO_SRC}/vendor" || die

	dobin bin/*
}
