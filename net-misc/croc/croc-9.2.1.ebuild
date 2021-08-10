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
	"github.com/cpuguy83/go-md2man/v2 v2.0.1"
	"github.com/cpuguy83/go-md2man/v2 v2.0.1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/denisbrodbeck/machineid v1.0.1"
	"github.com/denisbrodbeck/machineid v1.0.1/go.mod"
	"github.com/k0kubun/go-ansi v0.0.0-20180517002512-3bf9e2903213/go.mod"
	"github.com/kalafut/imohash v1.0.2"
	"github.com/kalafut/imohash v1.0.2/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/mattn/go-isatty v0.0.13/go.mod"
	"github.com/mattn/go-runewidth v0.0.13"
	"github.com/mattn/go-runewidth v0.0.13/go.mod"
	"github.com/mitchellh/colorstring v0.0.0-20190213212951-d06e56a500db"
	"github.com/mitchellh/colorstring v0.0.0-20190213212951-d06e56a500db/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
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
	"github.com/schollz/pake/v3 v3.0.2"
	"github.com/schollz/pake/v3 v3.0.2/go.mod"
	"github.com/schollz/peerdiscovery v1.6.6"
	"github.com/schollz/peerdiscovery v1.6.6/go.mod"
	"github.com/schollz/progressbar/v3 v3.8.2"
	"github.com/schollz/progressbar/v3 v3.8.2/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/spaolacci/murmur3 v0.0.0-20180118202830-f09979ecbc72/go.mod"
	"github.com/spaolacci/murmur3 v1.1.0"
	"github.com/spaolacci/murmur3 v1.1.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.6.1"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"github.com/tscholl2/siec v0.0.0-20191122224205-8da93652b094/go.mod"
	"github.com/tscholl2/siec v0.0.0-20210707234609-9bdfc483d499"
	"github.com/tscholl2/siec v0.0.0-20210707234609-9bdfc483d499/go.mod"
	"github.com/twmb/murmur3 v1.1.5"
	"github.com/twmb/murmur3 v1.1.5/go.mod"
	"golang.org/x/crypto v0.0.0-20210616213533-5ff15b29337e/go.mod"
	"golang.org/x/crypto v0.0.0-20210711020723-a769d52b0f97"
	"golang.org/x/crypto v0.0.0-20210711020723-a769d52b0f97/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/net v0.0.0-20210510120150-4163338589ed/go.mod"
	"golang.org/x/net v0.0.0-20210805182204-aaa1db679c0d"
	"golang.org/x/net v0.0.0-20210805182204-aaa1db679c0d/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
	"golang.org/x/sys v0.0.0-20210511113859-b0526f3d8744/go.mod"
	"golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
	"golang.org/x/sys v0.0.0-20210616094352-59db8d763f22/go.mod"
	"golang.org/x/sys v0.0.0-20210806184541-e5e7981a1069"
	"golang.org/x/sys v0.0.0-20210806184541-e5e7981a1069/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b"
	"golang.org/x/term v0.0.0-20210615171337-6886f2dfbf5b/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.6"
	"golang.org/x/text v0.3.6/go.mod"
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
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	acct-group/croc
	acct-user/croc
"

PATCHES=(
	"${FILESDIR}/${PN}-disable-network-tests-r1.patch"
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
