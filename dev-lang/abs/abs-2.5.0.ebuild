# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="The ABS programing language"
HOMEPAGE="https://github.com/abs-lang/abs https://www.abs-lang.org/"

EGO_SUM=(
"github.com/c-bata/go-prompt v0.2.4-0.20190826134812-0f95e1d1de2e"
"github.com/c-bata/go-prompt v0.2.4-0.20190826134812-0f95e1d1de2e/go.mod"
"github.com/iancoleman/strcase v0.0.0-20191112232945-16388991a334"
"github.com/iancoleman/strcase v0.0.0-20191112232945-16388991a334/go.mod"
"github.com/iancoleman/strcase v0.1.0"
"github.com/iancoleman/strcase v0.1.0/go.mod"
"github.com/jteeuwen/go-bindata v3.0.7+incompatible/go.mod"
"github.com/mattn/go-colorable v0.0.9/go.mod"
"github.com/mattn/go-colorable v0.1.4/go.mod"
"github.com/mattn/go-colorable v0.1.6"
"github.com/mattn/go-colorable v0.1.6/go.mod"
"github.com/mattn/go-colorable v0.1.7"
"github.com/mattn/go-colorable v0.1.7/go.mod"
"github.com/mattn/go-isatty v0.0.3/go.mod"
"github.com/mattn/go-isatty v0.0.8/go.mod"
"github.com/mattn/go-isatty v0.0.10/go.mod"
"github.com/mattn/go-isatty v0.0.12"
"github.com/mattn/go-isatty v0.0.12/go.mod"
"github.com/mattn/go-runewidth v0.0.3/go.mod"
"github.com/mattn/go-runewidth v0.0.6/go.mod"
"github.com/mattn/go-runewidth v0.0.9"
"github.com/mattn/go-runewidth v0.0.9/go.mod"
"github.com/mattn/go-tty v0.0.0-20180219170247-931426f7535a/go.mod"
"github.com/mattn/go-tty v0.0.3"
"github.com/mattn/go-tty v0.0.3/go.mod"
"github.com/pkg/term v0.0.0-20180423043932-cda20d4ac917/go.mod"
"github.com/pkg/term v0.0.0-20190109203006-aa71e9d9e942"
"github.com/pkg/term v0.0.0-20190109203006-aa71e9d9e942/go.mod"
"github.com/pkg/term v0.0.0-20200520122047-c3ffed290a03"
"github.com/pkg/term v0.0.0-20200520122047-c3ffed290a03/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20200323165209-0ec3e9974c59"
"golang.org/x/crypto v0.0.0-20200323165209-0ec3e9974c59/go.mod"
"golang.org/x/crypto v0.0.0-20200820211705-5c72a883971a"
"golang.org/x/crypto v0.0.0-20200820211705-5c72a883971a/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/sync v0.0.0-20190911185100-cd5d95a43a6e/go.mod"
"golang.org/x/sys v0.0.0-20180620133508-ad87a3a340fa/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
"golang.org/x/sys v0.0.0-20191008105621-543471e840be/go.mod"
"golang.org/x/sys v0.0.0-20191120155948-bd437916bb0e/go.mod"
"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod"
"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd"
"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
"golang.org/x/sys v0.0.0-20200824131525-c12d262b63d8"
"golang.org/x/sys v0.0.0-20200824131525-c12d262b63d8/go.mod"
"golang.org/x/text v0.3.0/go.mod"
)
go-module_set_globals
SRC_URI="https://github.com/abs-lang/abs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT+=" test"

src_prepare() {
	sed -e "s:^var Version = \"dev\"\$:var Version = \"${PV}\":" -i main.go || die
	default
}

src_compile() {
	CGO_ENABLED=0 emake build_simple || die
}

src_install() {
	dobin builds/abs
	dodoc README.md
}
