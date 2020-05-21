# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/adnanh/webhook
inherit eutils go-module

DESCRIPTION="lightweight incoming webhook server to run shell commands"
HOMEPAGE="https://github.com/adnanh/webhook/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adnanh/webhook/"
else
EGO_SUM=(
	"github.com/clbanning/mxj v1.8.4" # SPDX:MIT,BSD-3-Clause
	"github.com/clbanning/mxj v1.8.4/go.mod"
	"github.com/dustin/go-humanize v1.0.0" # SPDX:MIT
	"github.com/dustin/go-humanize v1.0.0/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7" # SPDX:BSD-3-Clause
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/ghodss/yaml v1.0.0" # SPDX:MIT,BSD-3-Clause
	"github.com/ghodss/yaml v1.0.0/go.mod"
	"github.com/go-chi/chi v4.0.2+incompatible" # SPDX:MIT
	"github.com/go-chi/chi v4.0.2+incompatible/go.mod"
	"github.com/gofrs/uuid v3.2.0+incompatible" # SPDX:MIT
	"github.com/gofrs/uuid v3.2.0+incompatible/go.mod"
	"github.com/gorilla/mux v1.7.3" # SPDX:BSD-3-Clause
	"github.com/gorilla/mux v1.7.3/go.mod"
	"github.com/kr/pretty v0.1.0" # SPDX:MIT
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod" # SPDX:MIT
	"github.com/kr/text v0.1.0" # SPDX:MIT
	"github.com/kr/text v0.1.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/net v0.0.0-20191209160850-c0dbc17a3553" # SPDX:BSD-3-Clause
	"golang.org/x/net v0.0.0-20191209160850-c0dbc17a3553/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a" # SPDX:BSD-3-Clause
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20191228213918-04cbcbbfeed8" # SPDX:BSD-3-Clause
	"golang.org/x/sys v0.0.0-20191228213918-04cbcbbfeed8/go.mod"
	"golang.org/x/text v0.3.0" # SPDX:BSD-3-Clause
	"golang.org/x/text v0.3.0/go.mod"
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15" # SPDX:BSD-2-Clause
	"gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.2" # SPDX:BSD-3-Clause
	"gopkg.in/fsnotify.v1 v1.4.2/go.mod"
	"gopkg.in/yaml.v2 v2.0.0-20170812160011-eb3733d160e7" # SPDX:Apache-2.0
	"gopkg.in/yaml.v2 v2.0.0-20170812160011-eb3733d160e7/go.mod"
)
go-module_set_globals
	SRC_URI="https://github.com/adnanh/webhook/archive/${PV}.tar.gz -> ${P}.tar.gz
			${EGO_SUM_SRC_URI}"
	KEYWORDS="~amd64"
	S="${WORKDIR}/webhook-${PV}"
fi

# SPDX:BSD-3-Clause is 'BSD' in Gentoo
# SPDX:BSD-2-Clause is 'BSD-2' in Gentoo
LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"

RDEPEND=""
BDEPEND=">=dev-lang/go-1.13"

DOCS=(
	README.md
	hooks.json.example
	hooks.json.tmpl.example
	hooks.yaml.example
	hooks.yaml.tmpl.example
	docs/Hook-Definition.md
	docs/Hook-Examples.md
	docs/Hook-Rules.md
	docs/Referencing-Request-Values.md
	docs/Templates.md
	docs/Webhook-Parameters.md
)

# Do not let these leak from outside into the package
unset GOBIN GOPATH GOCODE

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	# Golang LDFLAGS are not the same as GCC/Binutils LDFLAGS
	unset LDFLAGS
	go build
}

src_install() {
	dobin webhook
	einstalldocs
}
