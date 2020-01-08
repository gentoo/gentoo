# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/kbudde/rabbitmq_exporter
EGO_VENDOR=(
	"github.com/kbudde/gobert a6daecb9ddeb548b7cfb3f5ac9deef9ded522730"
	"github.com/prometheus/client_model f287a105a20ec685d797f65cd0ce8fbeaef42da1"
	"github.com/prometheus/common 2998b132700a7d019ff618c06a234b47c1f3f681"
	"github.com/prometheus/client_golang d2ead25884778582e740573999f7b07f47e171b4"
	"github.com/prometheus/procfs b1a0a9a36d7453ba0f62578b99712f3a6c5f82d1"
	"github.com/matttproud/golang_protobuf_extensions c182affec369e30f25d3eb8cd8a478dee585ae7d"
	"github.com/golang/protobuf 347cf4a86c1cb8d262994d8ef5924d4576c5b331"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/Sirupsen/logrus 78fb3852d92683dc28da6cc3d5f965100677c27d"
	"golang.org/x/crypto ff983b9c42bc9fbf91556e191cc8efb585c16908 github.com/golang/crypto"
	"golang.org/x/sys 2be51725563103c17124a318f1745b66f2347acb github.com/golang/sys"
)

inherit user golang-build golang-vcs-snapshot

DESCRIPTION="Rabbitmq exporter for Prometheus"
HOMEPAGE="https://github.com/kbudde/rabbitmq_exporter"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e "/-s$/d" -e "s/{{.Revision}}/v${PV}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix bin || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/${PN}
	dodoc *.md
	popd || die
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}
