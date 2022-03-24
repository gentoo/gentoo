# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
	"github.com/cli/safeexec v1.0.0" # BSD-2
	"github.com/cli/safeexec v1.0.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1" # ISC
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/kr/pretty v0.1.0" # MIT
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod" # MIT
	"github.com/kr/text v0.1.0" # MIT
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0" # BSD
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/spf13/pflag v1.0.5" # BSD
	"github.com/spf13/pflag v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod" # MIT
	"github.com/stretchr/testify v1.7.0" # MIT
	"github.com/stretchr/testify v1.7.0/go.mod"
	"github.com/yuin/goldmark v1.3.5/go.mod" # MIT
	"go.uber.org/goleak v1.1.12" # MIT
	"go.uber.org/goleak v1.1.12/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod" # BSD
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/lint v0.0.0-20190930215403-16217165b5de" # BSD
	"golang.org/x/lint v0.0.0-20190930215403-16217165b5de/go.mod"
	"golang.org/x/mod v0.4.2/go.mod" # BSD
	"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod" # BSD
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20210405180319-a5a99cb37ef4/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c" # BSD
	"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod" # BSD
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210330210617-4fbd30eecc44/go.mod"
	"golang.org/x/sys v0.0.0-20210510120138-977fb7262007/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod" # BSD
	"golang.org/x/text v0.3.0/go.mod" # BSD
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod" # BSD
	"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.1.5" # BSD
	"golang.org/x/tools v0.1.5/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod" # BSD
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127" # BSD
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c" # Apache-2.0
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="Compute various size metrics for a Git repository"
HOMEPAGE="https://github.com/github/git-sizer"
SRC_URI="https://github.com/github/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT Apache-2.0 BSD BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # tests work only in git repo

RDEPEND="dev-vcs/git"

src_compile() {
	emake GOFLAGS="${GOFLAGS} -ldflags=-X=main.BuildVersion=v${PV}"
}

src_install() {
	dobin bin/git-sizer
	dodoc README.md CONTRIBUTING.md
}
