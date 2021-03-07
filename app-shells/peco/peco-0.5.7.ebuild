# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Simplistic interactive filtering tool"

HOMEPAGE="https://github.com/peco/peco"

EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/google/btree v0.0.0-20161213163243-0c3044bc8bad"
	"github.com/google/btree v0.0.0-20161213163243-0c3044bc8bad/go.mod"
	"github.com/jessevdk/go-flags v1.1.0"
	"github.com/jessevdk/go-flags v1.1.0/go.mod"
	"github.com/lestrrat-go/pdebug v0.0.0-20180220043849-39f9a71bcabe"
	"github.com/lestrrat-go/pdebug v0.0.0-20180220043849-39f9a71bcabe/go.mod"
	"github.com/mattn/go-runewidth v0.0.0-20161012013512-737072b4e32b"
	"github.com/mattn/go-runewidth v0.0.0-20161012013512-737072b4e32b/go.mod"
	"github.com/nsf/termbox-go v0.0.0-20190817171036-93860e161317"
	"github.com/nsf/termbox-go v0.0.0-20190817171036-93860e161317/go.mod"
	"github.com/pkg/errors v0.0.0-20161029093637-248dadf4e906"
	"github.com/pkg/errors v0.0.0-20161029093637-248dadf4e906/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/testify v0.0.0-20161117074351-18a02ba4a312"
	"github.com/stretchr/testify v0.0.0-20161117074351-18a02ba4a312/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/peco/peco/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS=( {Changes,README.md} )

PATCHES=(
	"${FILESDIR}/${P}-go.sum.patch"
)

src_compile() {
	go build ./cmd/... || die "build failed"
}

src_test() {
	go test ./... || die "test failed"
}

src_install() {
	einstalldocs
	dobin peco
}
