# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
EGIT_COMMIT=738671d3881b9731cc63024d5d88cf28db875626

DESCRIPTION="a linter for Go"
HOMEPAGE="https://github.com/golang/lint"

EGO_SUM=(
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20200130002326-2f3ba24bd6e7"
	"golang.org/x/tools v0.0.0-20200130002326-2f3ba24bd6e7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/golang/lint/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/lint-${EGIT_COMMIT}

DOCS=(
	CONTRIBUTING.md
	README.md
	misc
)

src_compile() {
	env GOBIN="${S}/bin" go install ./... ||
		die "compile failed"
}

src_install() {
	dobin bin/*
	einstalldocs
}
