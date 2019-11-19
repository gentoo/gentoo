# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/armon/go-metrics ec5e00d3c878b2a97bbe0884ef45ffd1b4f669f5"
	"github.com/frankban/quicktest v1.4.0"
	"github.com/golang/snappy v0.0.1"
	"github.com/google/btree v1.0.0"
	"github.com/hashicorp/consul v1.2.0"
	"github.com/hashicorp/errwrap v1.0.0"
	"github.com/hashicorp/go-cleanhttp v0.5.1"
	"github.com/hashicorp/go-gatedio v0.5.0"
	"github.com/hashicorp/go-hclog v0.9.2"
	"github.com/hashicorp/go-immutable-radix v1.1.0"
	"github.com/hashicorp/go-msgpack v0.5.5"
	"github.com/hashicorp/go-multierror v1.0.0"
	"github.com/hashicorp/go-retryablehttp v0.6.2"
	"github.com/hashicorp/go-rootcerts v1.0.1"
	"github.com/hashicorp/go-sockaddr v1.0.2"
	"github.com/hashicorp/go-syslog v1.0.0"
	"github.com/hashicorp/golang-lru v0.5.3"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/hashicorp/logutils v1.0.0"
	"github.com/hashicorp/memberlist v0.1.4"
	"github.com/hashicorp/serf v0.8.3"
	"github.com/hashicorp/vault 746c0b111519166ff2126f55dba7071912c33006"
	"github.com/mattn/go-shellwords v1.0.5"
	"github.com/miekg/dns v1.1.15"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/mitchellh/hashstructure v1.0.0"
	"github.com/mitchellh/mapstructure v1.1.2"
	"github.com/pierrec/lz4 v2.2.5"
	"github.com/pkg/errors v0.8.1"
	"github.com/ryanuber/go-glob v1.0.0"
	"github.com/stretchr/testify v1.3.0"
	"golang.org/x/crypto 4def268fd1a49955bfb3dda92fe3db4f924f2285 github.com/golang/crypto"
	"golang.org/x/net ca1201d0de80cfde86cb01aea620983605dfe99b github.com/golang/net"
	"golang.org/x/sys 1393eb0183657fb29200106b17a5042ec6e48dbe github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/time c4c64cad1fd0a1a8dab2523e04e61d35308e131e github.com/golang/time"
	"gopkg.in/check.v1 788fd78401277ebd861206a03c884797c6ec5541 github.com/go-check/check"
	"gopkg.in/square/go-jose.v2 v2.3.1 github.com/square/go-jose"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
)

inherit golang-vcs-snapshot systemd user

KEYWORDS="~amd64"
DESCRIPTION="Generic template rendering and notifications with Consul"
GIT_COMMIT="521adf1"
EGO_PN="github.com/hashicorp/${PN}"
HOMEPAGE="https://github.com/hashicorp/consul-template"
LICENSE="MPL-2.0 Apache-2.0 BSD BSD-2 ISC MIT WTFPL-2"
SLOT="0"
# TODO: debug test failures
RESTRICT="test"

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
S=${WORKDIR}/${P}/src/${EGO_PN}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	# Avoid the need to have a git checkout
	sed -e "s:git rev-parse --short HEAD:echo ${GIT_COMMIT}:" \
		-e '/-s \\/d' \
		-i Makefile || die
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	export GO111MODULE=on GOFLAGS="-mod=vendor -v -x" GOBIN="${WORKDIR}/${P}/bin"
	emake dev
}

src_test() {
	emake test
}

src_install() {
	dobin "${GOBIN}/${PN}"
	dodoc {CHANGELOG.md,README.md}

	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	keepdir /etc/${PN}.d
}
