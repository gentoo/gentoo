# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGO_SUM=(
"github.com/BurntSushi/toml v0.3.1/go.mod"
"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d"
"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/jmespath/go-jmespath v0.4.0"
"github.com/jmespath/go-jmespath v0.4.0/go.mod"
"github.com/jmespath/go-jmespath/internal/testify v1.5.1"
"github.com/jmespath/go-jmespath/internal/testify v1.5.1/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/russross/blackfriday/v2 v2.0.1"
"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
"github.com/shurcooL/sanitized_anchor_name v1.0.0"
"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/urfave/cli v1.22.5"
"github.com/urfave/cli v1.22.5/go.mod"
"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
"gopkg.in/yaml.v2 v2.2.2/go.mod"
"gopkg.in/yaml.v2 v2.2.8/go.mod"
)
go-module_set_globals

MY_PN=jpp
MY_P=${MY_PN}-${PV}

DESCRIPTION="Command line interface to JMESPath"
HOMEPAGE="https://github.com/pipebus/jpp https://github.com/jmespath/jp/pull/30 http://jmespath.org"
SRC_URI="https://github.com/pipebus/jpp/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+jp +jpp"
RESTRICT+=" test"
REQUIRED_USE="|| ( jp jpp )"

S=${WORKDIR}/${MY_P}

src_compile() {
	if use jp; then
		go build -mod=readonly -o ./jp ./jp.go || die
	fi
	if use jpp; then
		go build -mod=readonly -o ./jpp ./cmd/jpp/main.go || die
	fi
}

src_install() {
	use jp && dobin "./jp"
	use jpp && dobin "./jpp"
	dodoc README.md
}
