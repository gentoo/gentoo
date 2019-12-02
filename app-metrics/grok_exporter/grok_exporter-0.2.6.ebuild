# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/fstab/grok_exporter
EGO_REVISION=81c0afe
EGO_VENDOR=(
	"github.com/prometheus/client_model 56726106282f1985ea77d5305743db7231b0c0a8"
	"github.com/prometheus/common 2998b132700a7d019ff618c06a234b47c1f3f681"
	"github.com/prometheus/client_golang 18d13eacc9cce330610a70daf4ed0fef2e846589"
	"github.com/prometheus/procfs b1a0a9a36d7453ba0f62578b99712f3a6c5f82d1"
	"github.com/matttproud/golang_protobuf_extensions c182affec369e30f25d3eb8cd8a478dee585ae7d"
	"github.com/golang/protobuf 347cf4a86c1cb8d262994d8ef5924d4576c5b331"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"gopkg.in/yaml.v2 51d6538a90f86fe93ac480b35f37b2be17fef232 github.com/go-yaml/yaml" # branch v2.2.2
)

inherit user golang-build golang-vcs-snapshot

DESCRIPTION="Unstructured log data exporter for Prometheus"
HOMEPAGE="https://github.com/fstab/Grok_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/oniguruma-6.9.0"
RDEPEND=">=dev-libs/oniguruma-6.9.0:="

RESTRICT="strip"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	cd src/${EGO_PN} || die
	GOPATH="${S}" go build -ldflags="
		-X ${EGO_PN}/exporter.Version=${PV}
		-X ${EGO_PN}/exporter.BuildDate=$(date +%Y-%m-%d)
		-X ${EGO_PN}/exporter.Branch=master
		-X ${EGO_PN}/exporter.Revision=${EGO_REVISION}" || die "compile failed"
}

src_install() {
	cd src/${EGO_PN} || die
	dobin ${PN}
	dodoc -r *.md example
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
keepdir /etc/"${PN}"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
	elog "You need to create /etc/${PN}/${PN}.yml"
	elog "Please see /usr/share/doc/${PVR} for examples"
	fi
}
