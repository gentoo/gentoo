# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit go-module

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/aws/aws-sdk-go v1.29.19"
	"github.com/aws/aws-sdk-go v1.29.19/go.mod"
	"github.com/bobisme/gucumber v0.0.0-20181101035029-55b04af03920"
	"github.com/bobisme/gucumber v0.0.0-20181101035029-55b04af03920/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/go-sql-driver/mysql v1.5.0/go.mod"
	"github.com/gucumber/gucumber v0.0.0-20160715015914-71608e2f6e76"
	"github.com/gucumber/gucumber v0.0.0-20160715015914-71608e2f6e76/go.mod"
	"github.com/gucumber/gucumber v0.0.0-20180127021336-7d5c79e832a2"
	"github.com/gucumber/gucumber v0.0.0-20180127021336-7d5c79e832a2/go.mod"
	"github.com/jmespath/go-jmespath v0.0.0-20180206201540-c2b33e8439af"
	"github.com/jmespath/go-jmespath v0.0.0-20180206201540-c2b33e8439af/go.mod"
	"github.com/miekg/dns v0.0.0-20170818131442-e4205768578d"
	"github.com/miekg/dns v0.0.0-20170818131442-e4205768578d/go.mod"
	"github.com/miekg/dns v1.1.31"
	"github.com/miekg/dns v1.1.31/go.mod"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.0.1"
	"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
	"github.com/shiena/ansicolor v0.0.0-20151119151921-a422bbe96644"
	"github.com/shiena/ansicolor v0.0.0-20151119151921-a422bbe96644/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/urfave/cli/v2 v2.2.0"
	"github.com/urfave/cli/v2 v2.2.0/go.mod"
	"github.com/wadey/gocovmerge v0.0.0-20160331181800-b5bfa59ec0ad"
	"github.com/wadey/gocovmerge v0.0.0-20160331181800-b5bfa59ec0ad/go.mod"
	"github.com/yuin/goldmark v1.1.32/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20191011191535-87dc89f01550/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/mod v0.1.1-0.20191105210325-c90efee705ee/go.mod"
	"golang.org/x/mod v0.3.0/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/net v0.0.0-20190923162816-aa69164e4478/go.mod"
	"golang.org/x/net v0.0.0-20200202094626-16171245cfb2"
	"golang.org/x/net v0.0.0-20200202094626-16171245cfb2/go.mod"
	"golang.org/x/net v0.0.0-20200625001655-4c5254603344"
	"golang.org/x/net v0.0.0-20200625001655-4c5254603344/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sync v0.0.0-20200625203802-6e8e738ad208/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20190924154521-2837fb4f24fe/go.mod"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
	"golang.org/x/tools v0.0.0-20191216052735-49a3e744a425/go.mod"
	"golang.org/x/tools v0.0.0-20200809012840-6f4f008689da"
	"golang.org/x/tools v0.0.0-20200809012840-6f4f008689da/go.mod"
	"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
	"golang.org/x/xerrors v0.0.0-20191011141410-1b5146add898/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
)

go-module_set_globals

DESCRIPTION="A command-line tool for Amazon Route 53"
HOMEPAGE="https://github.com/barnybug/cli53"
SRC_URI="https://github.com/barnybug/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT BSD BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# gucumber is required to run tests which is not yet packaged
RESTRICT="strip test"

DEPEND=">=dev-lang/go-1.14"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	GOBIN="${S}/bin" \
		emake install
}

src_install() {
	dobin bin/${PN}
	einstalldocs
}
