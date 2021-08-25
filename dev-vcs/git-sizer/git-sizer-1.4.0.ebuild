# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
	"github.com/cli/safeexec v1.0.0"  # BSD-2
	"github.com/cli/safeexec v1.0.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"  # ISC
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"  # BSD
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/spf13/pflag v1.0.5"  # BSD
	"github.com/spf13/pflag v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"  # MIT
	"github.com/stretchr/testify v1.4.0"  # MIT
	"github.com/stretchr/testify v1.4.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"  # BSD-2
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.7"  # Apache-2.0
	"gopkg.in/yaml.v2 v2.2.7/go.mod"
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
