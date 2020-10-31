# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module systemd

DESCRIPTION="Easily and securely send things from one computer to another"
HOMEPAGE="https://github.com/schollz/croc"

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/OneOfOne/xxhash v1.2.2/go.mod"
	"github.com/OneOfOne/xxhash v1.2.5"
	"github.com/OneOfOne/xxhash v1.2.5/go.mod"
	"github.com/cespare/xxhash v1.1.0"
	"github.com/cespare/xxhash v1.1.0/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/denisbrodbeck/machineid v1.0.1"
	"github.com/denisbrodbeck/machineid v1.0.1/go.mod"
	"github.com/k0kubun/go-ansi v0.0.0-20180517002512-3bf9e2903213/go.mod"
	"github.com/kalafut/imohash v1.0.0"
	"github.com/kalafut/imohash v1.0.0/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-runewidth v0.0.9"
	"github.com/mattn/go-runewidth v0.0.9/go.mod"
	"github.com/mitchellh/colorstring v0.0.0-20190213212951-d06e56a500db"
	"github.com/mitchellh/colorstring v0.0.0-20190213212951-d06e56a500db/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.0.1"
	"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
	"github.com/schollz/cli/v2 v2.2.1"
	"github.com/schollz/cli/v2 v2.2.1/go.mod"
	"github.com/schollz/logger v1.2.0"
	"github.com/schollz/logger v1.2.0/go.mod"
	"github.com/schollz/mnemonicode v1.0.1"
	"github.com/schollz/mnemonicode v1.0.1/go.mod"
	"github.com/schollz/pake/v2 v2.0.4"
	"github.com/schollz/pake/v2 v2.0.4/go.mod"
	"github.com/schollz/peerdiscovery v1.6.0"
	"github.com/schollz/peerdiscovery v1.6.0/go.mod"
	"github.com/schollz/progressbar/v2 v2.15.0"
	"github.com/schollz/progressbar/v2 v2.15.0/go.mod"
	"github.com/schollz/progressbar/v3 v3.6.2"
	"github.com/schollz/progressbar/v3 v3.6.2/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/spaolacci/murmur3 v0.0.0-20180118202830-f09979ecbc72/go.mod"
	"github.com/spaolacci/murmur3 v1.1.0"
	"github.com/spaolacci/murmur3 v1.1.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/tscholl2/siec v0.0.0-20191122224205-8da93652b094"
	"github.com/tscholl2/siec v0.0.0-20191122224205-8da93652b094/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20200604202706-70a84ac30bf9"
	"golang.org/x/crypto v0.0.0-20200604202706-70a84ac30bf9/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/crypto v0.0.0-20201002170205-7f63de1d35b0/go.mod"
	"golang.org/x/crypto v0.0.0-20201016220609-9e8e0b390897"
	"golang.org/x/crypto v0.0.0-20201016220609-9e8e0b390897/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20200707034311-ab3426394381"
	"golang.org/x/net v0.0.0-20200707034311-ab3426394381/go.mod"
	"golang.org/x/net v0.0.0-20201022231255-08b38378de70"
	"golang.org/x/net v0.0.0-20201022231255-08b38378de70/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
	"golang.org/x/sys v0.0.0-20200625212154-ddb9806d33ae"
	"golang.org/x/sys v0.0.0-20200625212154-ddb9806d33ae/go.mod"
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
	"golang.org/x/sys v0.0.0-20201009025420-dfb3f7c4e634/go.mod"
	"golang.org/x/sys v0.0.0-20201022201747-fb209a7c41cd"
	"golang.org/x/sys v0.0.0-20201022201747-fb209a7c41cd/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/tylerb/is.v1 v1.1.2"
	"gopkg.in/tylerb/is.v1 v1.1.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.7"
	"gopkg.in/yaml.v2 v2.2.7/go.mod"
	)
go-module_set_globals

SRC_URI="https://github.com/schollz/croc/releases/download/v${PV}/${PN}_${PV}_src.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/croc
	acct-user/croc
"

PATCHES=(
	"${FILESDIR}/${PN}-disable-network-tests.patch"
)

DOCS=( README.md )

src_prepare() {
	default
	# Replace User=nobody with User=croc
	sed -i -e "s|\(^User=\).*|\1croc|g" croc.service || die
	# Rename bash completion function
	sed -i -e "s|_cli_bash_autocomplete|_croc|g" \
		src/install/bash_autocomplete || die
}

src_compile() {
	go build || die
}

src_install() {
	dobin croc
	systemd_dounit croc.service
	newbashcomp src/install/bash_autocomplete croc
	einstalldocs
}

src_test() {
	go test -work ./... || die
}
