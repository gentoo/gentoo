# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module


DESCRIPTION="A small utility which generates Go code from any file"
HOMEPAGE="https://github.com/go-bindata/go-bindata"

EGO_SUM=(
	"github.com/kisielk/errcheck v1.2.0"
	"github.com/kisielk/errcheck v1.2.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/lint v0.0.0-20191125180803-fdd1cda4f05f"
	"golang.org/x/lint v0.0.0-20191125180803-fdd1cda4f05f/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563/go.mod"
	"golang.org/x/tools v0.0.0-20191125144606-a911d9008d1f"
	"golang.org/x/tools v0.0.0-20191125144606-a911d9008d1f/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/go-bindata/go-bindata/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="CC-PD"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~arm ~arm64"

src_compile() {
	GOBIN=${S}/bin \
		go install ./go-bindata/ || die
}

src_install() {
	dobin bin/*
	dodoc CONTRIBUTING.md README.md
}
