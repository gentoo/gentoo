# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_SUM=(
"github.com/armon/circbuf v0.0.0-20150827004946-bbbad097214e"
"github.com/armon/circbuf v0.0.0-20150827004946-bbbad097214e/go.mod"
"github.com/armon/go-metrics v0.0.0-20180917152333-f0300d1749da"
"github.com/armon/go-metrics v0.0.0-20180917152333-f0300d1749da/go.mod"
"github.com/armon/go-radix v0.0.0-20180808171621-7fddfc383310"
"github.com/armon/go-radix v0.0.0-20180808171621-7fddfc383310/go.mod"
"github.com/bgentry/speakeasy v0.1.0"
"github.com/bgentry/speakeasy v0.1.0/go.mod"
"github.com/davecgh/go-spew v1.1.0"
"github.com/davecgh/go-spew v1.1.0/go.mod"
"github.com/davecgh/go-spew v1.1.1"
"github.com/davecgh/go-spew v1.1.1/go.mod"
"github.com/fatih/color v1.7.0"
"github.com/fatih/color v1.7.0/go.mod"
"github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c"
"github.com/google/btree v0.0.0-20180813153112-4030bb1f1f0c/go.mod"
"github.com/hashicorp/errwrap v1.0.0"
"github.com/hashicorp/errwrap v1.0.0/go.mod"
"github.com/hashicorp/go-immutable-radix v1.0.0"
"github.com/hashicorp/go-immutable-radix v1.0.0/go.mod"
"github.com/hashicorp/go-msgpack v0.5.3"
"github.com/hashicorp/go-msgpack v0.5.3/go.mod"
"github.com/hashicorp/go-multierror v1.0.0"
"github.com/hashicorp/go-multierror v1.0.0/go.mod"
"github.com/hashicorp/go-sockaddr v1.0.0"
"github.com/hashicorp/go-sockaddr v1.0.0/go.mod"
"github.com/hashicorp/go-syslog v1.0.0"
"github.com/hashicorp/go-syslog v1.0.0/go.mod"
"github.com/hashicorp/go-uuid v1.0.0/go.mod"
"github.com/hashicorp/go-uuid v1.0.1"
"github.com/hashicorp/go-uuid v1.0.1/go.mod"
"github.com/hashicorp/go.net v0.0.1"
"github.com/hashicorp/go.net v0.0.1/go.mod"
"github.com/hashicorp/golang-lru v0.5.0"
"github.com/hashicorp/golang-lru v0.5.0/go.mod"
"github.com/hashicorp/logutils v1.0.0"
"github.com/hashicorp/logutils v1.0.0/go.mod"
"github.com/hashicorp/mdns v1.0.0"
"github.com/hashicorp/mdns v1.0.0/go.mod"
"github.com/hashicorp/memberlist v0.1.3"
"github.com/hashicorp/memberlist v0.1.3/go.mod"
"github.com/mattn/go-colorable v0.0.9"
"github.com/mattn/go-colorable v0.0.9/go.mod"
"github.com/mattn/go-isatty v0.0.3"
"github.com/mattn/go-isatty v0.0.3/go.mod"
"github.com/miekg/dns v1.0.14"
"github.com/miekg/dns v1.0.14/go.mod"
"github.com/mitchellh/cli v1.0.0"
"github.com/mitchellh/cli v1.0.0/go.mod"
"github.com/mitchellh/gox v0.4.0"
"github.com/mitchellh/gox v0.4.0/go.mod"
"github.com/mitchellh/iochan v1.0.0"
"github.com/mitchellh/iochan v1.0.0/go.mod"
"github.com/mitchellh/mapstructure v0.0.0-20160808181253-ca63d7c062ee"
"github.com/mitchellh/mapstructure v0.0.0-20160808181253-ca63d7c062ee/go.mod"
"github.com/pascaldekloe/goe v0.0.0-20180627143212-57f6aae5913c"
"github.com/pascaldekloe/goe v0.0.0-20180627143212-57f6aae5913c/go.mod"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/pmezard/go-difflib v1.0.0/go.mod"
"github.com/posener/complete v1.1.1"
"github.com/posener/complete v1.1.1/go.mod"
"github.com/ryanuber/columnize v0.0.0-20160712163229-9b3edd62028f"
"github.com/ryanuber/columnize v0.0.0-20160712163229-9b3edd62028f/go.mod"
"github.com/sean-/seed v0.0.0-20170313163322-e2103e2c3529"
"github.com/sean-/seed v0.0.0-20170313163322-e2103e2c3529/go.mod"
"github.com/stretchr/objx v0.1.0/go.mod"
"github.com/stretchr/testify v1.2.2/go.mod"
"github.com/stretchr/testify v1.3.0"
"github.com/stretchr/testify v1.3.0/go.mod"
"golang.org/x/crypto v0.0.0-20181029021203-45a5f77698d3"
"golang.org/x/crypto v0.0.0-20181029021203-45a5f77698d3/go.mod"
"golang.org/x/net v0.0.0-20181023162649-9b4f9f5ad519/go.mod"
"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc"
"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc/go.mod"
"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4"
"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
"golang.org/x/sys v0.0.0-20180823144017-11551d06cbcc/go.mod"
"golang.org/x/sys v0.0.0-20181026203630-95b1ffbd15a5"
"golang.org/x/sys v0.0.0-20181026203630-95b1ffbd15a5/go.mod"
)

inherit go-module systemd
go-module_set_globals

KEYWORDS="~amd64"
EGO_PN="github.com/hashicorp/serf"
DESCRIPTION="Service orchestration and management tool"
HOMEPAGE="https://www.serfdom.io/"
SRC_URI="https://github.com/hashicorp/serf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

SLOT="0"
LICENSE="MPL-2.0 Apache-2.0 BSD MIT"
IUSE=""
RESTRICT="test"
BDEPEND=""
RDEPEND="
	acct-user/serf
	acct-group/serf"

src_prepare() {
	default
	sed -e 's|\(^VERSION[[:space:]]*:=\).*|\1'${PV}'|' \
		-e 's|\(GITSHA[[:space:]]*:=\).*|\1'${PV}'|' \
		-e 's|\(GITBRANCH[[:space:]]*:=\).*|\1'${PV}'|' \
		-i  GNUmakefile || die
}

src_compile() {
	mkdir -p ./bin
	go build -o ./bin/serf ./cmd/serf || die
}

src_install() {
	local x

	dobin "${S}/bin/${PN}"

	keepdir /etc/serf.d
	insinto /etc/serf.d

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners serf:serf "${x}"
	done

	newinitd "${FILESDIR}/serf.initd" "${PN}"
	newconfd "${FILESDIR}/serf.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/serf.service"
}
