# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Format agnostic jQ"
HOMEPAGE="https://github.com/jzelinskie/faq"

EGO_SUM=(
	"github.com/Azure/draft v0.16.0"
	"github.com/Azure/draft v0.16.0/go.mod"
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/alecthomas/assert v0.0.0-20170929043011-405dbfeb8e38"
	"github.com/alecthomas/assert v0.0.0-20170929043011-405dbfeb8e38/go.mod"
	"github.com/alecthomas/chroma v0.6.2"
	"github.com/alecthomas/chroma v0.6.2/go.mod"
	"github.com/alecthomas/colour v0.0.0-20160524082231-60882d9e2721"
	"github.com/alecthomas/colour v0.0.0-20160524082231-60882d9e2721/go.mod"
	"github.com/alecthomas/kong v0.1.15/go.mod"
	"github.com/alecthomas/repr v0.0.0-20180818092828-117648cd9897/go.mod"
	"github.com/alecthomas/repr v0.0.0-20181024024818-d37bc2a10ba1"
	"github.com/alecthomas/repr v0.0.0-20181024024818-d37bc2a10ba1/go.mod"
	"github.com/clbanning/mxj v0.0.0-20180418195244-1f00e0bf9bac"
	"github.com/clbanning/mxj v0.0.0-20180418195244-1f00e0bf9bac/go.mod"
	"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964"
	"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dlclark/regexp2 v1.1.6"
	"github.com/dlclark/regexp2 v1.1.6/go.mod"
	"github.com/ghodss/yaml v1.0.0"
	"github.com/ghodss/yaml v1.0.0/go.mod"
	"github.com/globalsign/mgo v0.0.0-20180615134936-113d3961e731"
	"github.com/globalsign/mgo v0.0.0-20180615134936-113d3961e731/go.mod"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
	"github.com/jbrukh/bayesian v0.0.0-20161210175230-bf3f261f9a9c"
	"github.com/jbrukh/bayesian v0.0.0-20161210175230-bf3f261f9a9c/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/mattn/go-colorable v0.0.9/go.mod"
	"github.com/mattn/go-isatty v0.0.4"
	"github.com/mattn/go-isatty v0.0.4/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/sergi/go-diff v1.0.0"
	"github.com/sergi/go-diff v1.0.0/go.mod"
	"github.com/sirupsen/logrus v1.3.0"
	"github.com/sirupsen/logrus v1.3.0/go.mod"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/cobra v0.0.3/go.mod"
	"github.com/spf13/pflag v1.0.3"
	"github.com/spf13/pflag v1.0.3/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/zeebo/bencode v0.0.0-20180308174530-d522839ac797"
	"github.com/zeebo/bencode v0.0.0-20180308174530-d522839ac797/go.mod"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793/go.mod"
	"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
	"golang.org/x/sys v0.0.0-20181128092732-4ed8d59d0b35"
	"golang.org/x/sys v0.0.0-20181128092732-4ed8d59d0b35/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/jzelinskie/faq/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-misc/jq
	dev-libs/oniguruma"

RESTRICT+=" test"

src_compile() {
	go build \
		-ldflags '-X github.com/jzelinskie/faq/pkg/version.Version=${PV}' \
		-o ${PN} \
		./cmd/${PN} || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc README.md docs/examples.md
}
