# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A simple, modern and secure encryption tool (and Go library)"
HOMEPAGE="https://github.com/FiloSottile/age"

EGO_SUM=(
"filippo.io/edwards25519 v1.0.0-rc.1"
"filippo.io/edwards25519 v1.0.0-rc.1/go.mod"
"golang.org/x/crypto v0.0.0-20210817164053-32db794688a5"
"golang.org/x/crypto v0.0.0-20210817164053-32db794688a5/go.mod"
"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
"golang.org/x/sys v0.0.0-20210903071746-97244b99971b"
"golang.org/x/sys v0.0.0-20210903071746-97244b99971b/go.mod"
"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b"
"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b/go.mod"
"golang.org/x/text v0.3.3/go.mod"
"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
)
go-module_set_globals
SRC_URI="https://github.com/FiloSottile/age/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

S="${WORKDIR}/age-${PV}"

LICENSE="BSD"
#RESTRICT+=" test"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-go/gox"

src_compile() {
	go build -ldflags "-X main.Version=${PV}" -o . filippo.io/age/cmd/... || die
}

src_test() {
	go test -race filippo.io/age/cmd/... || die
}

src_install() {
	dobin age age-keygen
	doman doc/age.1 doc/age-keygen.1
	dodoc README.md
}
