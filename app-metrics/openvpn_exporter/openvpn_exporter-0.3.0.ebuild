# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGO_PN="github.com/kumina/openvpn_exporter"

DESCRIPTION="Prometheus Exporter for OpenVPN"
HOMEPAGE="https://github.com/kumina/openvpn_exporter"

EGO_SUM=(
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973"
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
	"github.com/gogo/protobuf v1.1.1"
	"github.com/gogo/protobuf v1.1.1/go.mod"
	"github.com/golang/protobuf v1.2.0"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
	"github.com/prometheus/client_golang v0.9.1"
	"github.com/prometheus/client_golang v0.9.1/go.mod"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910"
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
	"github.com/prometheus/common v0.0.0-20181020173914-7e9e6cabbd39"
	"github.com/prometheus/common v0.0.0-20181020173914-7e9e6cabbd39/go.mod"
	"github.com/prometheus/procfs v0.0.0-20181005140218-185b4288413d"
	"github.com/prometheus/procfs v0.0.0-20181005140218-185b4288413d/go.mod"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f"
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/kumina/openvpn_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	acct-user/openvpn_exporter
	acct-group/openvpn_exporter
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	go build -o ${PN} || die
}

src_install() {
	dobin ${PN}
	dodoc {CHANGELOG,README}.md
	keepdir "/var/log/${PN}"
	fowners ${PN}:${PN} "/var/log/${PN}"
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
