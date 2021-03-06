# Copyright 2020-2021 Gentoo Authors
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
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/mattn/go-runewidth v0.0.10"
	"github.com/mattn/go-runewidth v0.0.10/go.mod"
	"github.com/mitchellh/colorstring v0.0.0-20190213212951-d06e56a500db"
	"github.com/mitchellh/colorstring v0.0.0-20190213212951-d06e56a500db/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rivo/uniseg v0.1.0/go.mod"
	"github.com/rivo/uniseg v0.2.0"
	"github.com/rivo/uniseg v0.2.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
	"github.com/russross/blackfriday/v2 v2.1.0"
	"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
	"github.com/schollz/cli/v2 v2.2.1"
	"github.com/schollz/cli/v2 v2.2.1/go.mod"
	"github.com/schollz/logger v1.2.0"
	"github.com/schollz/logger v1.2.0/go.mod"
	"github.com/schollz/mnemonicode v1.0.1"
	"github.com/schollz/mnemonicode v1.0.1/go.mod"
	"github.com/schollz/pake/v2 v2.0.6"
	"github.com/schollz/pake/v2 v2.0.6/go.mod"
	"github.com/schollz/peerdiscovery v1.6.3"
	"github.com/schollz/peerdiscovery v1.6.3/go.mod"
	"github.com/schollz/progressbar/v3 v3.7.4"
	"github.com/schollz/progressbar/v3 v3.7.4/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/spaolacci/murmur3 v0.0.0-20180118202830-f09979ecbc72/go.mod"
	"github.com/spaolacci/murmur3 v1.1.0"
	"github.com/spaolacci/murmur3 v1.1.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.6.1"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"github.com/tscholl2/siec v0.0.0-20191122224205-8da93652b094"
	"github.com/tscholl2/siec v0.0.0-20191122224205-8da93652b094/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20201221181555-eec23a3978ad/go.mod"
	"golang.org/x/crypto v0.0.0-20210220033148-5ea612d1eb83"
	"golang.org/x/crypto v0.0.0-20210220033148-5ea612d1eb83/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20210119194325-5f4716e94777/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210124154548-22da62e12c0c/go.mod"
	"golang.org/x/sys v0.0.0-20210305034016-7844c3c200c3"
	"golang.org/x/sys v0.0.0-20210305034016-7844c3c200c3/go.mod"
	"golang.org/x/term v0.0.0-20201117132131-f5c789dd3221/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/term v0.0.0-20201210144234-2321bbc49cbf/go.mod"
	"golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d"
	"golang.org/x/term v0.0.0-20210220032956-6a3ed077a48d/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.5"
	"golang.org/x/text v0.3.5/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/tylerb/is.v1 v1.1.2"
	"gopkg.in/tylerb/is.v1 v1.1.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	)
go-module_set_globals

SRC_URI="https://github.com/schollz/croc/releases/download/v${PV}/${PN}_${PV}_src.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

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
