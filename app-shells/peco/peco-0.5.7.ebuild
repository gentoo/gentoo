# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=( "github.com/davecgh/go-spew v1.1.0"
	"github.com/google/btree 0c3044bc8bad"
	"github.com/jessevdk/go-flags v1.1.0"
	"github.com/lestrrat-go/pdebug 39f9a71bcabe"
	"github.com/mattn/go-runewidth 737072b4e32b"
	"github.com/nsf/termbox-go 93860e161317"
	"github.com/pkg/errors 248dadf4e906"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/stretchr/testify 18a02ba4a312" )

EGO_PN="github.com/peco/${PN}"

inherit go-module

DESCRIPTION="Simplistic interactive filtering tool"
HOMEPAGE="https://github.com/peco/peco"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS=( {Changes,README.md} )

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	go build ./cmd/... || die "build failed"
}

src_test() {
	go test -work ./... || die "test failed"
}

src_install() {
	einstalldocs
	dobin peco
}
