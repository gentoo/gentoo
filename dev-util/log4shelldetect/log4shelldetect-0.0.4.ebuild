# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="check for java programs vulnerable to log4shell"
HOMEPAGE="https://github.com/1lann/log4shelldetect"

EGO_SUM=(
	"github.com/fatih/color v1.13.0"
	"github.com/fatih/color v1.13.0/go.mod"
	"github.com/karrick/godirwalk v1.16.1"
	"github.com/karrick/godirwalk v1.16.1/go.mod"
	"github.com/mattn/go-colorable v0.1.9"
	"github.com/mattn/go-colorable v0.1.9/go.mod"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-isatty v0.0.14"
	"github.com/mattn/go-isatty v0.0.14/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20200223170610-d5e6a3e2c0ae/go.mod"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c"
	"golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/1lann/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	go build . || die
}

src_install() {
dobin log4shelldetect
dodoc README.md
}
