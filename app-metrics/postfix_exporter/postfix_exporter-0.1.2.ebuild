# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/coreos/go-systemd bebb2b01b0473b183e4624aaf8e23ae6f4b22417"
	"github.com/coreos/pkg 97fdf19511ea361ae1c100dd393cc47f8dcfa1e1"
	"github.com/prometheus/client_golang f504d69affe11ec1ccb2e5948127f86878c9fd57"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/golang/protobuf e09c5db296004fbe3f74490e84dcd62c3c5ddb1b"
	"github.com/prometheus/client_model 99fa1f4be8e564e8a6b613da7fa6f46c9edafc6c"
	"github.com/prometheus/common 38c53a9f4bfcd932d1b00bfc65e256a7fba6b37a"
	"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
	"github.com/prometheus/procfs 780932d4fbbe0e69b84c34c20f5c8d0981e109ea" )

inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/kumina/postfix_exporter"
ARCHIVE_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus Exporter for Postfix"
HOMEPAGE="https://github.com/kumina/postfix_exporter"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE="systemd"

DEPEND="systemd? ( sys-apps/systemd )"

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" \
		go build -tags "$(usex systemd '' 'nosystemd')" -v -o bin/${PN} || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/bin/${PN}
	dodoc src/${EGO_PN}/{CHANGELOG,README}.md
	local dir
	for dir in /var/{lib,log}/${PN}; do
		keepdir "${dir}"
		fowners ${PN}:${PN} "${dir}"
	done
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
