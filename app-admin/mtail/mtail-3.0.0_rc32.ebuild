# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"contrib.go.opencensus.io/exporter/jaeger v0.1.0 github.com/census-ecosystem/opencensus-go-exporter-jaeger"
	"github.com/apache/thrift 4c847372eb9af8ec0b21ace31840eaabfdf32660"
	"github.com/beorn7/perks v1.0.0"
	"github.com/flazz/togo babdbf21cff004ef3532451d562a2119ef0c54ee"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/golang/groupcache 5b532d6fd5efaf7fa130d4e859a2fde0fc3a9e1b"
	"github.com/golang/protobuf v1.3.2"
	"github.com/google/go-cmp v0.3.0"
	"github.com/hashicorp/golang-lru v0.5.1"
	"github.com/matttproud/golang_protobuf_extensions c182affec369e30f25d3eb8cd8a478dee585ae7d"
	"github.com/pkg/errors v0.8.1"
	"github.com/prometheus/client_golang v0.9.4"
	"github.com/prometheus/client_model fd36f4220a901265f90734c3183c5f0c91daa0b8"
	"github.com/prometheus/common v0.4.1"
	"github.com/prometheus/procfs v0.0.3"
	"golang.org/x/sync 112230192c580c3556b8cee6403af37a4fc5f28c github.com/golang/sync"
	"golang.org/x/sys fae7ac547cb717d141c433a2a173315e216b64c4 github.com/golang/sys"
	"golang.org/x/tools d73e1c7e250b19f9948138e2df37cea712e8f06f github.com/golang/tools"
	"google.golang.org/api v0.7.0 github.com/googleapis/google-api-go-client"
	"google.golang.org/genproto c506a9f9061087022822e8da603a52fc387115a8 github.com/googleapis/go-genproto"
	"google.golang.org/grpc v1.22.0 github.com/grpc/grpc-go"
	"go.opencensus.io v0.22.0 github.com/census-instrumentation/opencensus-go"
)

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"
EGIT_COMMIT="b5aa95d10fb3af7b843e3814bc65aedd983425d9"
EGO_PN="github.com/google/mtail"
SRC_URI="https://${EGO_PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
DESCRIPTION="A tool for extracting metrics from application logs"
HOMEPAGE="https://github.com/google/mtail"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RDEPEND="!app-misc/mtail"

RESTRICT="test"

src_prepare() {
	default
	sed -e 's|GO111MODULE=on go build|go build|' \
		-e '/go get/d' \
		-e 's|^branch :=.*|branch := master|' \
		-e "s|^version :=.*|version := v${PV/_/-}|" \
		-e "s|^revision :=.*|revision := ${EGIT_COMMIT}|" \
		-e "s|^release :=.*|release := v${PV/_/-}|" \
		-i "src/${EGO_PN}/Makefile" || die
}

src_compile() {
	export GOPATH="${S}"
	export -n GOCACHE XDG_CACHE_HOME
	go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}/vendor/golang.org/x/tools/cmd/goyacc" || die
	emake -C "src/${EGO_PN}"
}

src_install() {
	dobin src/github.com/google/mtail/mtail
	dodoc "src/${EGO_PN}/"{CONTRIBUTING.md,README.md,TODO}
}
