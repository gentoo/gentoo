# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGIT_COMMIT="v${PV}"
GO_TOOLS_ARCHIVE="go-tools-${PV}.tar.gz"
ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${GO_TOOLS_ARCHIVE}"
KEYWORDS="~amd64"
DESCRIPTION="\"Go please\" is the official Go language server"
HOMEPAGE="https://github.com/golang/tools/blob/master/gopls/README.md"
SLOT="0"
LICENSE="BSD"

EGO_SUM=(
"github.com/BurntSushi/toml v0.3.1/go.mod"
"github.com/BurntSushi/toml v1.0.0"
"github.com/BurntSushi/toml v1.0.0/go.mod"
"github.com/creack/pty v1.1.9/go.mod"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/davecgh/go-spew v1.1.1"
"github.com/davecgh/go-spew v1.1.1/go.mod"
"github.com/frankban/quicktest v1.14.2"
"github.com/frankban/quicktest v1.14.2/go.mod"
"github.com/google/go-cmp v0.5.7"
"github.com/google/go-cmp v0.5.7/go.mod"
"github.com/google/safehtml v0.0.2"
"github.com/google/safehtml v0.0.2/go.mod"
"github.com/jba/printsrc v0.2.2"
"github.com/jba/printsrc v0.2.2/go.mod"
"github.com/jba/templatecheck v0.6.0"
"github.com/jba/templatecheck v0.6.0/go.mod"
"github.com/kr/pretty v0.1.0/go.mod"
"github.com/kr/pretty v0.3.0"
"github.com/kr/pretty v0.3.0/go.mod"
"github.com/kr/pty v1.1.1/go.mod"
"github.com/kr/text v0.1.0/go.mod"
"github.com/kr/text v0.2.0"
"github.com/kr/text v0.2.0/go.mod"
"github.com/pkg/diff v0.0.0-20210226163009-20ebb0f2a09e/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/rogpeppe/go-internal v1.6.1/go.mod"
"github.com/rogpeppe/go-internal v1.8.1"
"github.com/rogpeppe/go-internal v1.8.1/go.mod"
"github.com/sergi/go-diff v1.1.0"
"github.com/sergi/go-diff v1.1.0/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/stretchr/testify v1.4.0"
"github.com/stretchr/testify v1.4.0/go.mod"
"github.com/yuin/goldmark v1.4.1/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
"golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
"golang.org/x/mod v0.5.1/go.mod"
"golang.org/x/mod v0.6.0-dev.0.20220106191415-9b9b3d81d5e3"
"golang.org/x/mod v0.6.0-dev.0.20220106191415-9b9b3d81d5e3/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
"golang.org/x/net v0.0.0-20211015210444-4f30a5c0130f/go.mod"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
"golang.org/x/sys v0.0.0-20211019181941-9d821ace8654/go.mod"
"golang.org/x/sys v0.0.0-20220209214540-3681064d5158"
"golang.org/x/sys v0.0.0-20220209214540-3681064d5158/go.mod"
"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
"golang.org/x/text v0.3.0/go.mod"
"golang.org/x/text v0.3.3/go.mod"
"golang.org/x/text v0.3.6/go.mod"
"golang.org/x/text v0.3.7"
"golang.org/x/text v0.3.7/go.mod"
"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
"gopkg.in/errgo.v2 v2.1.0/go.mod"
"gopkg.in/yaml.v2 v2.2.2/go.mod"
"gopkg.in/yaml.v2 v2.2.4"
"gopkg.in/yaml.v2 v2.2.4/go.mod"
"honnef.co/go/tools v0.2.2"
"honnef.co/go/tools v0.2.2/go.mod"
"mvdan.cc/gofumpt v0.3.0"
"mvdan.cc/gofumpt v0.3.0/go.mod"
"mvdan.cc/xurls/v2 v2.4.0"
"mvdan.cc/xurls/v2 v2.4.0/go.mod"
)

go-module_set_globals
SRC_URI="
	${ARCHIVE_URI}
	${EGO_SUM_SRC_URI}
"

S=${WORKDIR}/tools-${PV}/${PN}

src_unpack() {
	unpack "${GO_TOOLS_ARCHIVE}"
	go-module_setup_proxy
}

src_prepare() {
	default
	rm internal/regtest/misc/vendor_test.go || die
}

src_compile() {
	GOBIN="${S}/bin" CGO_ENABLED=0 go install ./...
	[[ -x bin/${PN} ]] || die "${PN} build failed"
}

src_test() {
	go test -work "./..." || die
}

src_install() {
	dobin bin/${PN}
	dodoc -r doc README.md
}
