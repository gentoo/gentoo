# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGIT_COMMIT="af93e7ef17b78dee3e346814731377d5ef7b89f3"
EGO_SUM=(
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751"
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751/go.mod"
	"github.com/alecthomas/units v0.0.0-20190717042225-c3de453c63f4"
	"github.com/alecthomas/units v0.0.0-20190717042225-c3de453c63f4/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/jarcoal/httpmock v1.0.4"
	"github.com/jarcoal/httpmock v1.0.4/go.mod"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/mitchellh/go-homedir v1.1.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190701094942-4def268fd1a4"
	"golang.org/x/crypto v0.0.0-20190701094942-4def268fd1a4/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
)

go-module_set_globals

DESCRIPTION="RDAP command line client"
HOMEPAGE="
	https://www.openrdap.org/
	https://github.com/openrdap/rdap
"
SRC_URI="
	https://github.com/openrdap/rdap/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}
"
S="${WORKDIR}/${PN/open/}-${EGIT_COMMIT}"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	go build ./cmd/rdap || die
}

src_install() {
	dobin rdap
	einstalldocs
}
