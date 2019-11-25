# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="prometheus exporter for dnsmasq"
HOMEPAGE="https://github.com/google/dnsmasq_exporter"

EGO_VENDOR=(
	"github.com/alecthomas/template a0175ee3bccc"
	"github.com/alecthomas/units 2efee857e7cf"
	"github.com/beorn7/perks v1.0.0"
	"github.com/golang/protobuf v1.3.1"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/miekg/dns v1.1.14"
	"github.com/prometheus/client_golang v0.9.4"
	"github.com/prometheus/client_model fd36f4220a90"
	"github.com/prometheus/common v0.4.1"
	"github.com/prometheus/procfs v0.0.2"
	"github.com/sirupsen/logrus v1.2.0"
	"golang.org/x/crypto 0709b304e793 github.com/golang/crypto"
	"golang.org/x/net adae6a3d119a github.com/golang/net"
	"golang.org/x/sync 112230192c58 github.com/golang/sync"
	"golang.org/x/sys 5ac8a444bdc5 github.com/golang/sys"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6 github.com/alecthomas/kingpin"
)
SRC_URI="https://github.com/google/dnsmasq_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

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
