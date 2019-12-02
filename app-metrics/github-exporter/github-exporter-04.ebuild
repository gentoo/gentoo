# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/infinityworks/github-exporter

EGO_VENDOR=(
	"github.com/beorn7/perks 3a771d9"
	"github.com/fatih/structs 878a968"
	"github.com/golang/protobuf 347cf4a"
	"github.com/infinityworks/go-common 7f20a14"
	"github.com/matttproud/golang_protobuf_extensions  c182aff"
	"github.com/prometheus/client_golang d2ead25"
	"github.com/prometheus/client_model f287a10"
	"github.com/prometheus/common 2998b13"
	"github.com/prometheus/procfs b1a0a9a"
	"github.com/sirupsen/logrus eef6b76"
	"golang.org/x/crypto ff983b9 github.com/golang/crypto"
	"golang.org/x/sys 48ac38b github.com/golang/sys"
)

inherit golang-build golang-vcs-snapshot systemd

DESCRIPTION="Github statistics exporter for prometheus"
HOMEPAGE="https://github.com/infinityworks/github-exporter"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	default
	sed -i -e 's/infinityworksltd/infinityworks/' \
		"src/${EGO_PN}/main.go" \
		"src/${EGO_PN}/config/config.go" \
		"src/${EGO_PN}/exporter/structs.go" \
		|| die "sed failed"
	sed -i -e 's/Sirupsen/sirupsen/' \
		"src/${EGO_PN}/main.go" \
		"src/${EGO_PN}/config/config.go" \
		"src/${EGO_PN}/exporter/gather.go" \
		"src/${EGO_PN}/exporter/http.go" \
		"src/${EGO_PN}/exporter/prometheus.go" \
		|| die "sed failed"
}

src_compile() {
	set -- env GOPATH="${S}" go build -v "${EGO_PN}"
	echo "$@"
	"$@" || die "build failed"
}

src_install() {
	dobin ${PN}
	cd "src/${EGO_PN}" || die
dodoc *.md
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Before you can use ${PN}, you must configure it in"
		elog "${EROOT}/etc/conf.d/${PN}"
	fi
}
