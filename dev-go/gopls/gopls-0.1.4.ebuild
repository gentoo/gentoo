# Copyright 2021 Gentoo Authors
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
"github.com/BurntSushi/toml v0.3.1"
"github.com/BurntSushi/toml v0.3.1/go.mod"
"github.com/davecgh/go-spew v0.0.0-20161028175848-04cdfd42973b/go.mod"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/davecgh/go-spew v1.1.1"
"github.com/davecgh/go-spew v1.1.1/go.mod"
"github.com/google/go-cmp v0.5.4/go.mod"
"github.com/google/go-cmp v0.5.5"
"github.com/google/go-cmp v0.5.5/go.mod"
"github.com/google/safehtml v0.0.2"
"github.com/google/safehtml v0.0.2/go.mod"
"github.com/jba/templatecheck v0.6.0"
"github.com/jba/templatecheck v0.6.0/go.mod"
"github.com/kisielk/gotool v1.0.0/go.mod"
"github.com/kr/pretty v0.1.0/go.mod"
"github.com/kr/pty v1.1.1/go.mod"
"github.com/kr/text v0.1.0/go.mod"
"github.com/pmezard/go-difflib v0.0.0-20151028094244-d8ed2627bdf0/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/rogpeppe/go-internal v1.5.2/go.mod"
"github.com/rogpeppe/go-internal v1.6.2/go.mod"
"github.com/sanity-io/litter v1.5.0"
"github.com/sanity-io/litter v1.5.0/go.mod"
"github.com/sergi/go-diff v1.1.0"
"github.com/sergi/go-diff v1.1.0/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/stretchr/testify v0.0.0-20161117074351-18a02ba4a312/go.mod"
"github.com/stretchr/testify v1.4.0"
"github.com/stretchr/testify v1.4.0/go.mod"
"github.com/yuin/goldmark v1.3.5/go.mod"
"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
"golang.org/x/mod v0.4.0/go.mod"
"golang.org/x/mod v0.4.2"
"golang.org/x/mod v0.4.2/go.mod"
"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
"golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4/go.mod"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c"
"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
"golang.org/x/sys v0.0.0-20210330210617-4fbd30eecc44/go.mod"
"golang.org/x/sys v0.0.0-20210510120138-977fb7262007"
"golang.org/x/sys v0.0.0-20210510120138-977fb7262007/go.mod"
"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
"golang.org/x/text v0.3.0/go.mod"
"golang.org/x/text v0.3.3/go.mod"
"golang.org/x/text v0.3.6"
"golang.org/x/text v0.3.6/go.mod"
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
"honnef.co/go/tools v0.1.4"
"honnef.co/go/tools v0.1.4/go.mod"
"honnef.co/go/tools v0.2.0"
"honnef.co/go/tools v0.2.0/go.mod"
"mvdan.cc/gofumpt v0.1.1"
"mvdan.cc/gofumpt v0.1.1/go.mod"
"mvdan.cc/xurls/v2 v2.2.0"
"mvdan.cc/xurls/v2 v2.2.0/go.mod"
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
