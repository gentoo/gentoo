# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/coreos/etcd ff6d6867b06e82bb011770130d6d9580818e0cce"
	"github.com/coreos/go-semver 5e3acbb5668c4c3deb4842615c4098eb61fb6b1e"
	"github.com/fsnotify/fsnotify ff7bc41d4007f67e5456703c34342df4e0113f64"
	"github.com/golang/protobuf c9c7427a2a70d2eb3bafa0ab2dc163e45f143317"
	"github.com/hashicorp/go-syslog b609c7d9de4658cded34a7336b90886c56f9dbdb"
	"github.com/hashicorp/golang-lru 0a025b7e63adc15a622f29b0b2c4c3848243bbf6"
	"github.com/mholt/caddy fbd6412359be76bcfbb2ba5cfdecbc273e040674"
	"github.com/flynn/go-shlex 3f9db97f856818214da2e1057f8ad84803971cff"
	"github.com/miekg/dns 765aea0018871a5acd99796645585323343ba39c"
	"github.com/opentracing/opentracing-go 6edb48674bd9467b8e91fda004f2bd7202d60ce4"
	"github.com/openzipkin/zipkin-go-opentracing c05f3400653380a1e1584a3c519f3bea88a935b3"
	"github.com/prometheus/client_golang 738ed6c0b9b30ec936d4b74c1600ae76324efff5"
	"github.com/Shopify/sarama 3efb95dad8fbcd194d3c06f7b9c40eabeb719b36"
	"github.com/apache/thrift 6582757752e62efea3f9786dddf0260efaa1f450"
	"github.com/beorn7/perks 4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9"
	"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
	"github.com/eapache/go-resiliency b86b1ec0dd4209a588dc1285cdd471e73525c0b3"
	"github.com/eapache/go-xerial-snappy bb955e01b9346ac19dc29eb16586c90ded99a98c"
	"github.com/eapache/queue 44cc805cf13205b55f69e14bcb69867d1ae92f98"
	"github.com/go-logfmt/logfmt 390ab7935ee28ec6b286364bba9b4dd6410cb3d5"
	"github.com/gogo/protobuf 100ba4e885062801d56799d78530b73b178a78f3"
	"github.com/golang/snappy 553a641470496b2327abcac10b36396bd98e45c9"
	"github.com/klauspost/crc32 1bab8b35b6bb565f92cbc97939610af9369f942a"
	"github.com/pierrec/lz4 90290f74b1b4d9c097f0a3b3c7eba2ef3875c699"
	"github.com/pierrec/xxHash 5a004441f897722c627870a981d02b29924215fa"
	"github.com/prometheus/client_model 6f3806018612930941127f2a7c6c453ba2c527d2"
	"github.com/prometheus/common 49fee292b27bfff7f354ee0f64e1bc4850462edf"
	"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
	"github.com/prometheus/procfs a1dba9ce8baed984a2495b658c82687f8157b98f"
	"github.com/rcrowley/go-metrics 1f30fe9094a513ce4c700b9a54458bbb0c96996c"
	"github.com/ugorji/go 708a42d246822952f38190a8d8c4e6b16a0e600c"
	"golang.org/x/net a6577fac2d73be281a500b310739095313165611 github.com/golang/net"
	"golang.org/x/sys 99f16d856c9836c42d24e7ab64ea72916925fa97 github.com/golang/sys"
	"google.golang.org/grpc c5a5dbc5005d9153f67df476a7b561c07b22dbc2 github.com/grpc/grpc-go" )

EGO_PN="github.com/${PN}/${PN}/..."

inherit golang-build golang-vcs-snapshot

EGIT_COMMIT="v${PV}"
ARCHIVE_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A DNS server that chains middleware"
HOMEPAGE="https://github.com/coredns/coredns"

SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN%/*} || die
	GOPATH="${S}" go build || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN%/*}
	dobin ${PN}
	dodoc README.md
	popd || die
}
