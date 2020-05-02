# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A zero-config tool to make locally trusted development certificates"
HOMEPAGE="https://github.com/FiloSottile/mkcert"

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/google/renameio v0.1.0/go.mod"
	"github.com/jessevdk/go-flags v1.4.0/go.mod"
	"github.com/kisielk/gotool v1.0.0/go.mod"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/rogpeppe/go-internal v1.3.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190510104115-cbcb75029529/go.mod"
	"golang.org/x/mod v0.0.0-20190513183733-4bf6d317e70e/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20191022074931-774d2ec196ee/go.mod"
	"golang.org/x/tools v0.0.0-20191108193012-7d206e10da11"
	"golang.org/x/tools v0.0.0-20191108193012-7d206e10da11/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/errgo.v2 v2.1.0/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	"honnef.co/go/tools v0.0.0-20191107024926-a9480a3ec3bc"
	"honnef.co/go/tools v0.0.0-20191107024926-a9480a3ec3bc/go.mod"
	"howett.net/plist v0.0.0-20181124034731-591f970eefbb"
	"howett.net/plist v0.0.0-20181124034731-591f970eefbb/go.mod"
	"software.sslmate.com/src/go-pkcs12 v0.0.0-20180114231543-2291e8f0f237"
	"software.sslmate.com/src/go-pkcs12 v0.0.0-20180114231543-2291e8f0f237/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/FiloSottile/mkcert/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_compile() {
	go build -tags release -ldflags "-X main.Version=${PV}"  -o ${PN} || die
}

src_install() {
	dobin mkcert
	dodoc README.md
}
