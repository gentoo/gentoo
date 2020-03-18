# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="A simple JIRA commandline client in Go"
HOMEPAGE="https://github.com/Netflix-Skunkworks/go-jira"

EGO_VENDOR=(
	"github.com/alecthomas/template a0175ee3bccc"
	"github.com/alecthomas/units 2efee857e7cf"
	"github.com/cheekybits/genny v1.0.0"
	"github.com/coryb/figtree 58176d03ef0d"
	"github.com/coryb/kingpeon 9a669f143f2e"
	"github.com/coryb/oreo 3e1b88fc08f1"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/fatih/camelcase v1.0.0"
	"github.com/guelfey/go.dbus f6a3a2366cc3"
	"github.com/jinzhu/copier 7e38e58719c3"
	"github.com/kballard/go-shellquote 95032a82bc51"
	"github.com/mattn/go-colorable v0.0.9"
	"github.com/mattn/go-isatty v0.0.3"
	"github.com/mgutz/ansi 9520e82c474b"
	"github.com/pkg/browser c90ca0c84f15"
	"github.com/pkg/errors v0.8.0"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/stretchr/testify v1.2.2"
	"github.com/theckman/go-flock v0.4.0"
	"github.com/tidwall/gjson ba784d767ac7"
	"github.com/tidwall/match v1.0.0"
	"github.com/tmc/keyring 839169085ae1"
	"golang.org/x/crypto c126467f60eb github.com/golang/crypto"
	"golang.org/x/net 01c190206fbd github.com/golang/net"
	"golang.org/x/sys bd9dbc187b6e github.com/golang/sys"
	"gopkg.in/AlecAivazis/survey.v1 v1.6.1 github.com/AlecAivazis/survey"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6 github.com/alecthomas/kingpin"
	"gopkg.in/coryb/yaml.v2 0e40e46f7153 github.com/coryb/yaml"
	"gopkg.in/op/go-logging.v1 b2cb9fa56473 github.com/op/go-logging"
)

SRC_URI="https://github.com/go-jira/jira/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/jira-${PV}"

src_compile() {
	go build -o jira  cmd/jira/main.go || die
}

src_install() {
	dobin jira
	dodoc {CHANGELOG,README}.md
}
