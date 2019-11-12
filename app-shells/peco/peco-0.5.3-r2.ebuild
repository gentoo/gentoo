# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=( "github.com/google/btree 0c3044bc8bada22db67b93f5760fe3f05d6a5c25"
	"github.com/jessevdk/go-flags 8bc97d602c3bfeb5fc6fc9b5a9c898f245495637"
	"github.com/lestrrat/go-pdebug 2e6eaaa5717f81bda41d27070d3c966f40a1e75f"
	"github.com/mattn/go-runewidth 737072b4e32b7a5018b4a7125da8d12de90e8045"
	"github.com/nsf/termbox-go e2050e41c8847748ec5288741c0b19a8cb26d084"
	"github.com/pkg/errors 248dadf4e9068a0b3e79f02ed0a610d935de5302"
	"github.com/stretchr/testify 18a02ba4a312f95da08ff4cfc0055750ce50ae9e" )

EGO_PN="github.com/peco/${PN}"

inherit golang-vcs-snapshot

DESCRIPTION="Simplistic interactive filtering tool"
HOMEPAGE="https://github.com/peco/peco"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

DOCS=( src/"${EGO_PN}"/{Changes,README.md} )

src_prepare() {
	default

	# Don't install dependencies, make build verbose
	sed -i -e '/peco\$(SUFFIX):/s/ installdeps//' \
		-e '/test:/s/ installdeps//' \
		-e '/go build/s/-o/-v -x -o/' \
		-e '/go test -v/s#$(INTERNAL_BIN_DIR)/$(THIS_GOOS)/$(THIS_GOARCH)/##' \
		src/"${EGO_PN}"/Makefile || die "sed failed"
}

src_compile() {
	GOPATH="${S}:$(get_golibdir_gopath)" emake -C src/"${EGO_PN}" build
}

src_install() {
	einstalldocs
	dobin src/"${EGO_PN}"/releases/peco_linux_amd64/peco
}
