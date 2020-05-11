# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# bash-completion-r1 can be added once we can generate completion scripts
inherit go-module

DESCRIPTION="A simple JIRA commandline client in Go"
HOMEPAGE="https://github.com/Netflix-Skunkworks/go-jira"

EGO_SUM=(
	"github.com/Masterminds/goutils v1.1.0"
	"github.com/Masterminds/goutils v1.1.0/go.mod"
	"github.com/Masterminds/semver v1.5.0"
	"github.com/Masterminds/semver v1.5.0/go.mod"
	"github.com/Masterminds/sprig v2.21.0+incompatible"
	"github.com/Masterminds/sprig v2.21.0+incompatible/go.mod"
	"github.com/Netflix/go-expect v0.0.0-20180928190340-9d1f4485533b"
	"github.com/Netflix/go-expect v0.0.0-20180928190340-9d1f4485533b/go.mod"
	"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc"
	"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc/go.mod"
	"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf"
	"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf/go.mod"
	"github.com/cheekybits/genny v1.0.0"
	"github.com/cheekybits/genny v1.0.0/go.mod"
	"github.com/coryb/figtree v0.0.0-20180728224503-071d1ef303df"
	"github.com/coryb/figtree v0.0.0-20180728224503-071d1ef303df/go.mod"
	"github.com/coryb/figtree v1.0.1-0.20190907170512-58176d03ef0d"
	"github.com/coryb/figtree v1.0.1-0.20190907170512-58176d03ef0d/go.mod"
	"github.com/coryb/kingpeon v0.0.0-20180107011214-9a669f143f2e"
	"github.com/coryb/kingpeon v0.0.0-20180107011214-9a669f143f2e/go.mod"
	"github.com/coryb/oreo v0.0.0-20180804211640-3e1b88fc08f1"
	"github.com/coryb/oreo v0.0.0-20180804211640-3e1b88fc08f1/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/fatih/camelcase v1.0.0"
	"github.com/fatih/camelcase v1.0.0/go.mod"
	"github.com/google/uuid v1.1.1"
	"github.com/google/uuid v1.1.1/go.mod"
	"github.com/guelfey/go.dbus v0.0.0-20131113121618-f6a3a2366cc3"
	"github.com/guelfey/go.dbus v0.0.0-20131113121618-f6a3a2366cc3/go.mod"
	"github.com/hinshun/vt10x v0.0.0-20180809195222-d55458df857c"
	"github.com/hinshun/vt10x v0.0.0-20180809195222-d55458df857c/go.mod"
	"github.com/huandu/xstrings v1.2.0"
	"github.com/huandu/xstrings v1.2.0/go.mod"
	"github.com/imdario/mergo v0.3.7"
	"github.com/imdario/mergo v0.3.7/go.mod"
	"github.com/jinzhu/copier v0.0.0-20180308034124-7e38e58719c3"
	"github.com/jinzhu/copier v0.0.0-20180308034124-7e38e58719c3/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/pty v1.1.4"
	"github.com/kr/pty v1.1.4/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/mattn/go-colorable v0.0.9"
	"github.com/mattn/go-colorable v0.0.9/go.mod"
	"github.com/mattn/go-isatty v0.0.3"
	"github.com/mattn/go-isatty v0.0.3/go.mod"
	"github.com/mattn/go-runewidth v0.0.6"
	"github.com/mattn/go-runewidth v0.0.6/go.mod"
	"github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b"
	"github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b/go.mod"
	"github.com/olekukonko/tablewriter v0.0.3"
	"github.com/olekukonko/tablewriter v0.0.3/go.mod"
	"github.com/pkg/browser v0.0.0-20170505125900-c90ca0c84f15"
	"github.com/pkg/browser v0.0.0-20170505125900-c90ca0c84f15/go.mod"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/testify v1.2.2"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/theckman/go-flock v0.4.0"
	"github.com/theckman/go-flock v0.4.0/go.mod"
	"github.com/tidwall/gjson v0.0.0-20180711011033-ba784d767ac7"
	"github.com/tidwall/gjson v0.0.0-20180711011033-ba784d767ac7/go.mod"
	"github.com/tidwall/match v1.0.0"
	"github.com/tidwall/match v1.0.0/go.mod"
	"github.com/tmc/keyring v0.0.0-20171121202319-839169085ae1"
	"github.com/tmc/keyring v0.0.0-20171121202319-839169085ae1/go.mod"
	"golang.org/x/crypto v0.0.0-20180723164146-c126467f60eb"
	"golang.org/x/crypto v0.0.0-20180723164146-c126467f60eb/go.mod"
	"golang.org/x/net v0.0.0-20171102191033-01c190206fbd"
	"golang.org/x/net v0.0.0-20171102191033-01c190206fbd/go.mod"
	"golang.org/x/sys v0.0.0-20180727230415-bd9dbc187b6e"
	"golang.org/x/sys v0.0.0-20180727230415-bd9dbc187b6e/go.mod"
	"gopkg.in/AlecAivazis/survey.v1 v1.6.1"
	"gopkg.in/AlecAivazis/survey.v1 v1.6.1/go.mod"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/coryb/yaml.v2 v2.0.0-20180616071044-0e40e46f7153"
	"gopkg.in/coryb/yaml.v2 v2.0.0-20180616071044-0e40e46f7153/go.mod"
	"gopkg.in/op/go-logging.v1 v1.0.0-20160211212156-b2cb9fa56473"
	"gopkg.in/op/go-logging.v1 v1.0.0-20160211212156-b2cb9fa56473/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/go-jira/jira/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD-2 BSD ISC MIT MIT-with-advertising"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}/jira-${PV}"

src_compile() {
	go build -o jira  cmd/jira/main.go || die
	# these cause failures.
#	./jira --completion-script-bash > jira.bash || die
#	./jira --completion-script-zsh > jira.zsh || die
}

src_install() {
	dobin jira
	dodoc {CHANGELOG,README}.md
	# This can be uncommented once we can generate completion scripts
#	newbashcomp jira.bash jira
#	insinto /usr/share/zsh/site-functions
#	newins jira.zsh _jira
}
