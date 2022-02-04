# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/maxmind/${PN}"
EGO_SUM=(
	"github.com/creack/pty v1.1.9/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/gofrs/flock v0.8.1"
	"github.com/gofrs/flock v0.8.1/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/kr/text v0.2.0"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e"
	"github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/spf13/pflag v1.0.5"
	"github.com/spf13/pflag v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.7.0"
	"github.com/stretchr/testify v1.7.0/go.mod"
	"golang.org/x/sys v0.0.0-20201026173827-119d4633e4d1"
	"golang.org/x/sys v0.0.0-20201026173827-119d4633e4d1/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b"
	"gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776"
	"gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776/go.mod"
)

inherit go-module

go-module_set_globals

DESCRIPTION="Performs automatic updates of GeoIP2 and GeoIP Legacy binary databases"
HOMEPAGE="https://github.com/maxmind/geoipupdate"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="ISC BSD BSD-2 MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"

DOCS=( README.md CHANGELOG.md doc/GeoIP.conf.md doc/geoipupdate.md )

# Do not let these leak from outside into the package
export GOBIN= GOPATH= GOCODE=

src_compile() {
	# requires pandoc but the information is still in the distributed md files
	sed -i -e '/GeoIP.conf.5 /d' -e '/geoipupdate.1$/d' Makefile || die
	#sed -i -e 's/go build/go build -x/' Makefile || die

	# the horror, the horror ... but it's all automagic
	export CONFFILE=/etc/GeoIP.conf
	export DATADIR=/usr/share/GeoIP
	export VERSION=${PV}
	default
}

src_install() {
	dobin build/geoipupdate

	keepdir /usr/share/GeoIP

	insinto /etc
	doins build/GeoIP.conf

	einstalldocs
}
