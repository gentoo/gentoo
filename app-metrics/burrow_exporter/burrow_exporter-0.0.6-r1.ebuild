# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"github.com/beorn7/perks 4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9"
	"github.com/golang/protobuf 2bba0603135d7d7f5cb73b2125beeda19c09f4ef"
	"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
	"github.com/prometheus/client_golang 42552c195dd3f3089fbf9cf26e139da150af35aa"
	"github.com/prometheus/client_model 6f3806018612930941127f2a7c6c453ba2c527d2"
	"github.com/prometheus/common 13ba4ddd0caa9c28ca7b7bffe1dfa9ed8d5ef207"
	"github.com/prometheus/procfs 65c1f6f8f0fc1e2185eb9863a3bc751496404259"
	"github.com/Sirupsen/logrus ba1b36c82c5e05c4f912a88eab0dcd91a171688f"
	"github.com/urfave/cli ab403a54a148f2d857920810291539e1f817ee7b"
)
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/jirwin/burrow_exporter"
EXPORTER_COMMIT="01f0ef9"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for Burrow"
HOMEPAGE="https://github.com/jirwin/burrow_exporter"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	pushd src/${EGO_PN} || die
	eapply "${FILESDIR}"/${P}-skippable-metrics.patch "${FILESDIR}"/${P}-fix-metrics.patch
	sed -i -e "s/0.0.5/${PV}/" burrow-exporter.go || die
	popd || die
	default
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -v -o bin/burrow_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/burrow_exporter
	dodoc README.md
	popd || die
	keepdir /var/log/burrow_exporter
	fowners ${PN}:${PN} /var/log/burrow_exporter
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" ${PN}
}
