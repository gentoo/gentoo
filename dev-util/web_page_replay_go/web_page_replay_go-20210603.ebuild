# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod"
	"github.com/kylelemons/godebug v1.1.0"
	"github.com/kylelemons/godebug v1.1.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.0.1"
	"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/urfave/cli v1.22.4"
	"github.com/urfave/cli v1.22.4/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/net v0.0.0-20200602114024-627f9648deb9"
	"golang.org/x/net v0.0.0-20200602114024-627f9648deb9/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20200323222414-85ca7c5b95cd/go.mod"
	"golang.org/x/text v0.3.0"
	"golang.org/x/text v0.3.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	)
go-module_set_globals

SRC_URI="https://github.com/elkablo/web_page_replay_go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"
S="${WORKDIR}/${P}/src"

DESCRIPTION="A performance testing tool for recording and replaying web pages"
HOMEPAGE="https://chromium.googlesource.com/catapult/+/refs/heads/main/web_page_replay_go/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

src_unpack() {
	go-module_src_unpack
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/wpr-usage.patch"
	)

	default

	# default certificate, key and inject script in /usr/share/web_page_replay_go
	local f
	for f in wpr.go webpagereplay/legacyformatconvertor.go; do
		sed -i -e 's^"\(wpr_cert\.pem\|wpr_key\.pem\|deterministic\.js\)"^"/usr/share/web_page_replay_go/\1"^' "${f}" || die "sed-editing ${f} failed"
	done
}

src_compile() {
	local t

	for t in wpr.go httparchive.go; do
		go build ${GOFLAGS} -mod=mod "${t}" || die "compiling ${t} failed"
	done
}

src_install() {
	dobin wpr
	dobin httparchive

	insinto /usr/share/${PN}
	doins ../deterministic.js
	doins ../wpr_cert.pem
	doins ../wpr_key.pem
	doins ../wpr_public_hash.txt
}
