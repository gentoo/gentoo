# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A simple, modern and secure encryption tool (and Go library)"
HOMEPAGE="https://github.com/FiloSottile/age"

MY_PV=$(ver_cut 1-3)-rc.$(ver_cut 5)

EGO_SUM=(
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20201221181555-eec23a3978ad"
"golang.org/x/crypto v0.0.0-20201221181555-eec23a3978ad/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037"
"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
"golang.org/x/term v0.0.0-20201117132131-f5c789dd3221"
"golang.org/x/term v0.0.0-20201117132131-f5c789dd3221/go.mod"
"golang.org/x/text v0.3.0/go.mod"
)
go-module_set_globals
SRC_URI="https://github.com/FiloSottile/age/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

S="${WORKDIR}/age-${MY_PV}"

LICENSE="BSD"
#RESTRICT+=" test"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-go/gox"

src_compile() {
	go build -ldflags "-X main.Version=${MY_PV}" -o . filippo.io/age/cmd/... || die
}

src_test() {
	go test -race filippo.io/age/cmd/... || die
}

src_install() {
	dobin age age-keygen
	dodoc README.md
}
