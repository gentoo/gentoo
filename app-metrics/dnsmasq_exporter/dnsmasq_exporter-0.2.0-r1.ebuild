# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="prometheus exporter for dnsmasq"
HOMEPAGE="https://github.com/google/dnsmasq_exporter"

EGO_SUM=(
	"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc"
	"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc/go.mod"
	"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf"
	"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf/go.mod"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/beorn7/perks v1.0.0"
	"github.com/beorn7/perks v1.0.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/go-kit/kit v0.8.0/go.mod"
	"github.com/go-logfmt/logfmt v0.3.0/go.mod"
	"github.com/go-stack/stack v1.8.0/go.mod"
	"github.com/gogo/protobuf v1.1.1/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.3.1"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/json-iterator/go v1.1.6/go.mod"
	"github.com/julienschmidt/httprouter v1.2.0/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
	"github.com/kr/logfmt v0.0.0-20140226030751-b84e30acd515/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
	"github.com/miekg/dns v1.1.14"
	"github.com/miekg/dns v1.1.14/go.mod"
	"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
	"github.com/modern-go/reflect2 v1.0.1/go.mod"
	"github.com/mwitkow/go-conntrack v0.0.0-20161129095857-cc309e4a2223/go.mod"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prometheus/client_golang v0.9.1/go.mod"
	"github.com/prometheus/client_golang v0.9.4"
	"github.com/prometheus/client_golang v0.9.4/go.mod"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
	"github.com/prometheus/client_model v0.0.0-20190129233127-fd36f4220a90"
	"github.com/prometheus/client_model v0.0.0-20190129233127-fd36f4220a90/go.mod"
	"github.com/prometheus/common v0.4.1"
	"github.com/prometheus/common v0.4.1/go.mod"
	"github.com/prometheus/procfs v0.0.0-20181005140218-185b4288413d/go.mod"
	"github.com/prometheus/procfs v0.0.2"
	"github.com/prometheus/procfs v0.0.2/go.mod"
	"github.com/sirupsen/logrus v1.2.0"
	"github.com/sirupsen/logrus v1.2.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.1.1/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793"
	"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793/go.mod"
	"golang.org/x/net v0.0.0-20181114220301-adae6a3d119a"
	"golang.org/x/net v0.0.0-20181114220301-adae6a3d119a/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58"
	"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
	"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
	"golang.org/x/sys v0.0.0-20181116152217-5ac8a444bdc5"
	"golang.org/x/sys v0.0.0-20181116152217-5ac8a444bdc5/go.mod"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/google/dnsmasq_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/dnsmasq_exporter
	acct-user/dnsmasq_exporter"
	RDEPEND="${DEPEND}"

src_compile() {
	go build || die
}

src_install() {
	dobin dnsmasq_exporter
	keepdir /var/log/dnsmasq_exporter
	fowners ${PN}:${PN} /var/log/dnsmasq_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}

pkg_postinst() {
	if [[ -e "${EROOT}"/var/log/ddnsmasq_exporter ]]; then
		elog "The log directory is now ${EROOT}/var/log/dnsmasq_exporter"
		elog "in order 	to fix a typo."
	fi
}
