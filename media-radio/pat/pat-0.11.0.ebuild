# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module golang-build

EGO_PN=github.com/la5nta/pat

EGO_SUM=(
	"github.com/albenik/go-serial/v2 v2.1.0/go.mod"
	"github.com/albenik/go-serial/v2 v2.3.0"
	"github.com/albenik/go-serial/v2 v2.3.0/go.mod"
	"github.com/aymerick/douceur v0.2.0"
	"github.com/aymerick/douceur v0.2.0/go.mod"
	"github.com/bndr/gotabulate v1.1.3-0.20170315142410-bc555436bfd5"
	"github.com/bndr/gotabulate v1.1.3-0.20170315142410-bc555436bfd5/go.mod"
	"github.com/chris-ramon/douceur v0.2.0"
	"github.com/chris-ramon/douceur v0.2.0/go.mod"
	"github.com/creack/goselect v0.1.1/go.mod"
	"github.com/creack/goselect v0.1.2"
	"github.com/creack/goselect v0.1.2/go.mod"
	"github.com/creack/pty v1.1.9/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dimchansky/utfbom v1.1.1"
	"github.com/dimchansky/utfbom v1.1.1/go.mod"
	"github.com/fsnotify/fsnotify v1.4.9"
	"github.com/fsnotify/fsnotify v1.4.9/go.mod"
	"github.com/gorhill/cronexpr v0.0.0-20180427100037-88b0669f7d75"
	"github.com/gorhill/cronexpr v0.0.0-20180427100037-88b0669f7d75/go.mod"
	"github.com/gorilla/css v1.0.0"
	"github.com/gorilla/css v1.0.0/go.mod"
	"github.com/gorilla/mux v1.8.0"
	"github.com/gorilla/mux v1.8.0/go.mod"
	"github.com/gorilla/websocket v1.4.2"
	"github.com/gorilla/websocket v1.4.2/go.mod"
	"github.com/harenber/ptc-go/pactor/v2 v2.0.0-20201106165819-10108cccf409"
	"github.com/harenber/ptc-go/pactor/v2 v2.0.0-20201106165819-10108cccf409/go.mod"
	"github.com/howeyc/crc16 v0.0.0-20171223171357-2b2a61e366a6"
	"github.com/howeyc/crc16 v0.0.0-20171223171357-2b2a61e366a6/go.mod"
	"github.com/howeyc/gopass v0.0.0-20190910152052-7cb4b85ec19c"
	"github.com/howeyc/gopass v0.0.0-20190910152052-7cb4b85ec19c/go.mod"
	"github.com/kr/pretty v0.2.1/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/la5nta/wl2k-go v0.7.3/go.mod"
	"github.com/la5nta/wl2k-go v0.7.4"
	"github.com/la5nta/wl2k-go v0.7.4/go.mod"
	"github.com/mattn/go-runewidth v0.0.3/go.mod"
	"github.com/mattn/go-runewidth v0.0.9"
	"github.com/mattn/go-runewidth v0.0.9/go.mod"
	"github.com/microcosm-cc/bluemonday v1.0.4"
	"github.com/microcosm-cc/bluemonday v1.0.4/go.mod"
	"github.com/nfnt/resize v0.0.0-20180221191011-83c6a9932646"
	"github.com/nfnt/resize v0.0.0-20180221191011-83c6a9932646/go.mod"
	"github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e/go.mod"
	"github.com/paulrosania/go-charset v0.0.0-20151028000031-621bb39fcc83/go.mod"
	"github.com/paulrosania/go-charset v0.0.0-20190326053356-55c9d7a5834c"
	"github.com/paulrosania/go-charset v0.0.0-20190326053356-55c9d7a5834c/go.mod"
	"github.com/pd0mz/go-maidenhead v0.0.0-20170221185439-faa09c24425e"
	"github.com/pd0mz/go-maidenhead v0.0.0-20170221185439-faa09c24425e/go.mod"
	"github.com/peterh/liner v1.2.0"
	"github.com/peterh/liner v1.2.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/spf13/pflag v1.0.5"
	"github.com/spf13/pflag v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"github.com/stretchr/testify v1.7.0"
	"github.com/stretchr/testify v1.7.0/go.mod"
	"github.com/tarm/goserial v0.0.0-20151007205400-b3440c3c6355/go.mod"
	"go.uber.org/atomic v1.7.0"
	"go.uber.org/atomic v1.7.0/go.mod"
	"go.uber.org/multierr v1.6.0"
	"go.uber.org/multierr v1.6.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/crypto v0.0.0-20201016220609-9e8e0b390897"
	"golang.org/x/crypto v0.0.0-20201016220609-9e8e0b390897/go.mod"
	"golang.org/x/net v0.0.0-20181220203305-927f97764cc3/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20201031054903-ff519b6c9102"
	"golang.org/x/net v0.0.0-20201031054903-ff519b6c9102/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9/go.mod"
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
	"golang.org/x/sys v0.0.0-20201101102859-da207088b7d1/go.mod"
	"golang.org/x/sys v0.0.0-20201106081118-db71ae66460a/go.mod"
	"golang.org/x/sys v0.0.0-20210223212115-eede4237b368"
	"golang.org/x/sys v0.0.0-20210223212115-eede4237b368/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b/go.mod"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b"
	"gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b/go.mod"
	)

go-module_set_globals

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"
KEYWORDS="~amd64 ~x86"

GOLANG_PKG_HAVE_TEST=1

DESCRIPTION="Cross platform Winlink client with basic messaging capabilities."
HOMEPAGE="https://github.com/la5nta/pat"
LICENSE="MIT"

IUSE="ax25 hamlib"

DEPEND="ax25? ( media-radio/ax25-tools )
	hamlib? ( media-libs/hamlib )"

RDEPEND="${DEPEND}"

SLOT="0"

golang-vcs-snapshot_src_unpack() {
	default
}

src_compile() {
	if ! use ax25 && ! use hamlib; then
		go get -tags '' -u github.com/la5nta/pat
	elif use ax25 && ! use hamlib; then
		go get -tags 'libax25' -u github.com/la5nta/pat
	elif use hamlib && ! use ax25 ; then
		go get -tags 'hamlib' -u github.com/la5nta/pat
	elif use hamlib &&  use ax25 ; then
		go get -tags 'libax25 hamlib' -u github.com/la5nta/pat
	fi
}

src_install() {
	dobin ../../homedir/go/bin/pat
	dodoc README.md CONTRIBUTING.md cfg/example_config.json
	doman man/pat.1
	doman man/pat-configure.1
}

src_test() {
	"go test -tags "$TAGS" `go list ./...|grep -v vendor` \
	`go list ./...|grep wl2k-go|egrep -v '/vendor/.*/vendor/'`"
}
