# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"contrib.go.opencensus.io/exporter/jaeger v0.1.0 github.com/census-ecosystem/opencensus-go-exporter-jaeger"
	"github.com/apache/thrift v0.12.0"
	"github.com/beorn7/perks v1.0.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/golang/groupcache 869f871628b6baa9cfbc11732cdf6546b17c1298"
	"github.com/golang/protobuf v1.3.2"
	"github.com/google/go-cmp v0.3.0"
	"github.com/hashicorp/golang-lru v0.5.1"
	"github.com/matttproud/golang_protobuf_extensions c182affec369e30f25d3eb8cd8a478dee585ae7d"
	"github.com/pkg/errors v0.8.1"
	"github.com/prometheus/client_golang v1.0.0"
	"github.com/prometheus/client_model fd36f4220a901265f90734c3183c5f0c91daa0b8"
	"github.com/prometheus/common v0.6.0"
	"github.com/prometheus/procfs v0.0.3"
	"golang.org/x/sync 112230192c580c3556b8cee6403af37a4fc5f28c github.com/golang/sync"
	"golang.org/x/sys 51ab0e2deafac1f46c46ad59cf0921be2f180c3d github.com/golang/sys"
	"golang.org/x/tools e713427fea3f98cb070e72a058c557a1a560cf22 github.com/golang/tools"
	"google.golang.org/api v0.7.0 github.com/googleapis/google-api-go-client"
	"google.golang.org/genproto c506a9f9061087022822e8da603a52fc387115a8 github.com/googleapis/go-genproto"
	"google.golang.org/grpc v1.22.0 github.com/grpc/grpc-go"
	"go.opencensus.io v0.22.0 github.com/census-instrumentation/opencensus-go"
)

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"
EGIT_COMMIT="aedde73f9c304e4d558a53ece22a5472c87a7fdb"
EGO_PN="github.com/google/mtail"
SRC_URI="https://${EGO_PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
DESCRIPTION="A tool for extracting metrics from application logs"
HOMEPAGE="https://github.com/google/mtail"
LICENSE="Apache-2.0 MPL-2.0 BSD BSD-2 MIT"
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
