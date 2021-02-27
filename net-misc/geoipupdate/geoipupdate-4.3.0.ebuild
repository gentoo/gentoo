# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/maxmind/${PN}"

inherit eutils go-module

DESCRIPTION="performs automatic updates of GeoIP2 and GeoIP Legacy binary databases"
HOMEPAGE="https://github.com/maxmind/geoipupdate"
EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1" # SPDX:ISC
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/gofrs/flock v0.7.1" # SPDX:BSD-3-Clause
	"github.com/gofrs/flock v0.7.1/go.mod"
	"github.com/kr/pretty v0.2.0" # SPDX:MIT
	"github.com/kr/pretty v0.2.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0" # SPDX:MIT
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/maxmind/geoipupdate v4.0.2+incompatible" # SPDX:MIT, SPDX:Apache
	"github.com/pkg/errors v0.9.0" # SPDX:BSD-2-Clause
	"github.com/pkg/errors v0.9.0/go.mod"
	"github.com/pkg/errors v0.9.1" # SPDX:BSD-2-Clause
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0" # SPDX:BSD-3-Clause
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/spf13/pflag v1.0.5" # SPDX:BSD-3-Clause
	"github.com/spf13/pflag v1.0.5/go.mod"
	"github.com/stretchr/objx v0.1.0" # SPDX:MIT
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0" # SPDX:MIT
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.5.0" # SPDX:MIT
	"github.com/stretchr/testify v1.5.0/go.mod"
	"github.com/stretchr/testify v1.5.1" # SPDX:MIT
	"github.com/stretchr/testify v1.5.1/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15" # SPDX:BSD-2-Clause
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/yaml.v2 v2.2.2" # SPDX:Apache-2.0, SPDX:MIT
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.7" # SPDX:Apache-2.0, SPDX:MIT
	"gopkg.in/yaml.v2 v2.2.7/go.mod"
)
go-module_set_globals
SRC_URI="
	https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}
"

LICENSE="ISC BSD BSD-2 MIT Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 x86"

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
