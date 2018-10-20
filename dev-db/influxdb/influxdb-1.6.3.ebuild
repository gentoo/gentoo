# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/influxdata/${PN}
EGO_VENDOR=(
"collectd.org e84e8af5356e7f47485bbc95c96da6dd7984a67e github.com/collectd/go-collectd"
"github.com/BurntSushi/toml a368813c5e648fee92e5f6c30e3944ff9d5e8895"
"github.com/RoaringBitmap/roaring cefad6e4f79d4fa5d1d758ff937dde300641ccfa"
"github.com/beorn7/perks 4c0e84591b9aa9e6dcfdf3e020114cd81f89d5f9"
"github.com/bmizerany/pat c068ca2f0aacee5ac3681d68e4d0a003b7d1fd2c"
"github.com/boltdb/bolt 4b1ebc1869ad66568b313d0dc410e2be72670dda"
"github.com/cespare/xxhash 1b6d2e40c16ba0dfce5c8eac2480ad6e7394819b"
"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
"github.com/dgrijalva/jwt-go 24c63f56522a87ec5339cc3567883f1039378fdb"
"github.com/dgryski/go-bitstream 7d46cd22db7004f0cceb6f7975824b560cf0e486"
"github.com/glycerine/go-unsnap-stream 62a9a9eb44fd8932157b1a8ace2149eff5971af6"
"github.com/gogo/protobuf 1c2b16bc280d6635de6c52fc1471ab962dc36ec9"
"github.com/golang/protobuf 1e59b77b52bf8e4b449a57e6f79f21226d571845"
"github.com/golang/snappy d9eb7a3d35ec988b8585d4a0068e462c27d28380"
"github.com/google/go-cmp 18107e6c56edb2d51f965f7d68e59404f0daee54"
"github.com/influxdata/influxql 21ddebb5641365d9b92234e8f5a566c41da9ab48"
"github.com/influxdata/usage-client 6d3895376368aa52a3a81d2a16e90f0f52371967"
"github.com/influxdata/yamux 1f58ded512de5feabbe30b60c7d33a7a896c5f16"
"github.com/influxdata/yarpc 036268cdec22b7074cd6d50cc6d7315c667063c7"
"github.com/jsternberg/zap-logfmt 5ea53862c7fa897f44ae0b3004283308c0b0c9d1"
"github.com/jwilder/encoding 27894731927e49b0a9023f00312be26733744815"
"github.com/klauspost/compress 6c8db69c4b49dd4df1fff66996cf556176d0b9bf"
"github.com/klauspost/cpuid ae7887de9fa5d2db4eaa8174a7eff2c1ac00f2da"
"github.com/klauspost/crc32 cb6bfca970f6908083f26f39a79009d608efd5cd"
"github.com/klauspost/pgzip 0bf5dcad4ada2814c3c00f996a982270bb81a506"
"github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
"github.com/mschoch/smat 90eadee771aeab36e8bf796039b8c261bebebe4f"
"github.com/opentracing/opentracing-go 1361b9cd60be79c4c3a7fa9841b3c132e40066a7"
"github.com/paulbellamy/ratecounter 5a11f585a31379765c190c033b6ad39956584447"
"github.com/peterh/liner 88609521dc4b6c858fd4c98b628147da928ce4ac"
"github.com/philhofer/fwd 1612a298117663d7bc9a760ae20d383413859798"
"github.com/prometheus/client_golang 661e31bf844dfca9aeba15f27ea8aa0d485ad212"
"github.com/prometheus/client_model 99fa1f4be8e564e8a6b613da7fa6f46c9edafc6c"
"github.com/prometheus/common 2e54d0b93cba2fd133edc32211dcc32c06ef72ca"
"github.com/prometheus/procfs a6e9df898b1336106c743392c48ee0b71f5c4efa"
"github.com/retailnext/hllpp 38a7bb71b483e855d35010808143beaf05b67f9d"
"github.com/tinylib/msgp ad0ff2e232ad2e37faf67087fb24bf8d04a8ce20"
"github.com/willf/bitset d860f346b89450988a379d7d705e83c58d1ea227"
"github.com/xlab/treeprint 06dfc6fa17cdde904617990a0c2d89e3e332dbb3"
"go.uber.org/atomic 54f72d32435d760d5604f17a82e2435b28dc4ba5 github.com/uber-go/atomic"
"go.uber.org/multierr fb7d312c2c04c34f0ad621048bbb953b168f9ff6 github.com/uber-go/multierr"
"go.uber.org/zap 35aad584952c3e7020db7b839f6b102de6271f89 github.com/uber-go/zap"
"golang.org/x/crypto 9477e0b78b9ac3d0b03822fd95422e2fe07627cd github.com/golang/crypto"
"golang.org/x/net 9dfe39835686865bff950a07b394c12a98ddc811 github.com/golang/net"
"golang.org/x/sync fd80eb99c8f653c847d294a001bdf2a3a6f768f5 github.com/golang/sync"
"golang.org/x/sys 062cd7e4e68206d8bab9b18396626e855c992658 github.com/golang/sys"
"golang.org/x/text a71fd10341b064c10f4a81ceac72bcf70f26ea34 github.com/golang/text"
"golang.org/x/time 6dc17368e09b0e8634d71cac8168d853e869a0c7 github.com/golang/time"
	)

inherit golang-build golang-vcs-snapshot systemd user

DESCRIPTION=" Scalable datastore for metrics, events, and real-time analytics"
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
