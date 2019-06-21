# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/influxdata/${PN}
EGO_VENDOR=(
	"collectd.org 2ce144541b8903101fb8f1483cc0497a68798122 github.com/collectd/go-collectd"
	"github.com/apache/arrow f5df77359953ed06e1dce47edffc03340e2ff3ea"
	"github.com/BurntSushi/toml a368813c5e648fee92e5f6c30e3944ff9d5e8895"
	"github.com/beorn7/perks 4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9"
	"github.com/bmizerany/pat 6226ea591a40176dd3ff9cd8eff81ed6ca721a00"
	"github.com/boltdb/bolt 2f1ce7a837dcb8da3ec595b1dac9d0632f0f99e8"
	"github.com/c-bata/go-prompt e99fbc797b795e0a7a94affc8d44f6a0350d85f0"
	"github.com/cespare/xxhash 5c37fe3735342a2e0d01c87a907579987c8936cc"
	"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
	"github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
	"github.com/dgryski/go-bitstream 9f22ccc24718d9643ac427c8c897ae1a01575783"
	"github.com/glycerine/go-unsnap-stream 62a9a9eb44fd8932157b1a8ace2149eff5971af6"
	"github.com/go-sql-driver/mysql 72cd26f257d44c1114970e19afddcd812016007e"
	"github.com/gogo/protobuf 636bf0302bc95575d69441b25a2603156ffdddf1"
	"github.com/golang/protobuf b4deda0973fb4c70b50d226b1af49f3da59f5265"
	"github.com/golang/snappy d9eb7a3d35ec988b8585d4a0068e462c27d28380"
	"github.com/google/go-cmp 3af367b6b30c263d47e8895973edcca9a49cf029"
	"github.com/influxdata/flux bcfc535fb7443776501797df4ba596483c50c7fe"
	"github.com/influxdata/influxql 1cbfca8e56b6eaa120f5b5161e4f0d5edcc9e513"
	"github.com/influxdata/line-protocol a3afd890113fb9f0337e05808bb06fb0ca4c685a"
	"github.com/influxdata/roaring fc520f41fab6dcece280e8d4853d87a09a67f9e0"
	"github.com/influxdata/tdigest bf2b5ad3c0a925c44a0d2842c5d8182113cd248e"
	"github.com/influxdata/usage-client 6d3895376368aa52a3a81d2a16e90f0f52371967"
	"github.com/jsternberg/zap-logfmt ac4bd917e18a4548ce6e0e765b29a4e7f397b0b6"
	"github.com/jwilder/encoding b4e1701a28efcc637d9afcca7d38e495fe909a09"
	"github.com/klauspost/compress 6c8db69c4b49dd4df1fff66996cf556176d0b9bf"
	"github.com/klauspost/cpuid ae7887de9fa5d2db4eaa8174a7eff2c1ac00f2da"
	"github.com/klauspost/crc32 cb6bfca970f6908083f26f39a79009d608efd5cd"
	"github.com/klauspost/pgzip 0bf5dcad4ada2814c3c00f996a982270bb81a506"
	"github.com/lib/pq 4ded0e9383f75c197b3a2aaa6d590ac52df6fd79"
	"github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
	"github.com/mattn/go-runewidth 9e777a8366cce605130a531d2cd6363d07ad7317"
	"github.com/matttproud/golang_protobuf_extensions 3247c84500bff8d9fb6d579d800f20b3e091582c"
	"github.com/mschoch/smat 90eadee771aeab36e8bf796039b8c261bebebe4f"
	"github.com/opentracing/opentracing-go 328fceb7548c744337cd010914152b74eaf4c4ab"
	"github.com/paulbellamy/ratecounter 524851a93235ac051e3540563ed7909357fe24ab"
	"github.com/peterh/liner 6106ee4fe3e8435f18cd10e34557e5e50f0e792a"
	"github.com/philhofer/fwd bb6d471dc95d4fe11e432687f8b70ff496cf3136"
	"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
	"github.com/pkg/term bffc007b7fd5a70e20e28f5b7649bb84671ef436"
	"github.com/prometheus/client_golang 661e31bf844dfca9aeba15f27ea8aa0d485ad212"
	"github.com/prometheus/client_model 99fa1f4be8e564e8a6b613da7fa6f46c9edafc6c"
	"github.com/prometheus/common e4aa40a9169a88835b849a6efb71e05dc04b88f0"
	"github.com/prometheus/procfs 54d17b57dd7d4a3aa092476596b3f8a933bde349"
	"github.com/retailnext/hllpp 101a6d2f8b52abfc409ac188958e7e7be0116331"
	"github.com/satori/go.uuid f58768cc1a7a7e77a3bd49e98cdd21419399b6a3"
	"github.com/segmentio/kafka-go 0b3aacc527812d4040e51211146a43545e82d670"
	"github.com/spf13/cast 8c9545af88b134710ab1cd196795e7f2388358d7"
	"github.com/tinylib/msgp b2b6a672cf1e5b90748f79b8b81fc8c5cf0571a1"
	"github.com/willf/bitset d860f346b89450988a379d7d705e83c58d1ea227"
	"github.com/xlab/treeprint f3a15cfd24bf976c724324cb6846a8b54b88b639"
	"go.uber.org/atomic 8474b86a5a6f79c443ce4b2992817ff32cf208b8 github.com/uber-go/atomic"
	"go.uber.org/multierr 3c4937480c32f4c13a875a1829af76c98ca3d40a github.com/uber-go/multierr"
	"go.uber.org/zap 35aad584952c3e7020db7b839f6b102de6271f89 github.com/uber-go/zap"
	"golang.org/x/crypto c3a3ad6d03f7a915c0f7e194b7152974bb73d287 github.com/golang/crypto"
	"golang.org/x/net 92b859f39abd2d91a854c9f9c4621b2f5054a92d github.com/golang/net"
	"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
	"golang.org/x/sys d8e400bc7db4870d786864138af681469693d18c github.com/golang/sys"
	"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
	"golang.org/x/time 26559e0f760e39c24d730d3224364aef164ee23f github.com/golang/time"
	"google.golang.org/genproto fedd2861243fd1a8152376292b921b394c7bef7e github.com/google/go-genproto"
	"google.golang.org/grpc 168a6198bcb0ef175f7dacec0b8691fc141dc9b8 github.com/grpc/grpc-go"
	)

inherit golang-build golang-vcs-snapshot systemd user

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=app-text/asciidoc-8.6.10
	app-text/xmlto"

pkg_setup() {
	enewgroup influxdb
	enewuser influxdb -1 -1 /var/lib/influxdb influxdb
}

src_compile() {
	pushd "src/${EGO_PN}" > /dev/null || die
	set -- env GOPATH="${S}" go build -v -work -x ./...
	echo "$@"
	"$@" || die "compile failed"
	cd man
	emake build
	popd > /dev/null
}

src_install() {
	pushd "src/${EGO_PN}" > /dev/null || die
	set -- env GOPATH="${S}" go install -v -work -x ./...
	echo "$@"
	"$@" || die
	dobin "${S}"/bin/influx*
	dodoc CHANGELOG.md etc/config.sample.toml
	doman man/*.1
	insinto /etc/logrotate.d
	newins scripts/logrotate influxdb
	systemd_dounit scripts/influxdb.service
	newconfd "${FILESDIR}"/influxdb.confd influxdb
	newinitd "${FILESDIR}"/influxdb.rc influxdb
	insinto /etc/influxdb
	doins "${FILESDIR}"/influxd.conf
	keepdir /var/log/influxdb
	fowners influxdb:influxdb /var/log/influxdb
	popd > /dev/null || die
}
