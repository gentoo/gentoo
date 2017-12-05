# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/docopt/docopt-go 784ddc588536785e7299f7272f39101f7faccc3f"
	"github.com/mcuadros/go-version 257f7b9a7d87427c8d7f89469a5958d57f8abd7c"
	"github.com/mitchellh/go-ps 4fdf99ab29366514c69ccccddab5dc58b8d84062"
	"github.com/olekukonko/tablewriter be5337e7b39e64e5f91445ce7e721888dbab7387"
	"github.com/mattn/go-runewidth 97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
	"github.com/osrg/gobgp bbd1d99396fef6503e308d1851ecf91c31006635"
	"github.com/armon/go-radix 1fca145dffbcaa8fe914309b1ec0cfc67500fe61"
	"github.com/eapache/channels 47238d5aae8c0fefd518ef2bee46290909cf8263"
	"github.com/eapache/queue 44cc805cf13205b55f69e14bcb69867d1ae92f98"
	"github.com/golang/protobuf 4bd1920723d7b7c925de087aa32e2187708897f7"
	"github.com/influxdata/influxdb 392fa03cf3cc98b78e606c34996976cea65b6814"
	"github.com/projectcalico/go-json 6219dc7339ba20ee4c57df0a8baac62317d19cb1"
	"github.com/projectcalico/go-yaml-wrapper 598e54215bee41a19677faa4f0c32acd2a87eb56"
	"github.com/projectcalico/libcalico-go 25a8c377d7b3299a50197a92704d606f5f5ca691"
	"github.com/coreos/etcd 17ae440991da3bdb2df4309936dd2074f66ec394"
	"github.com/kelseyhightower/envconfig f611eb38b3875cc3bd991ca91c51d06446afa14c"
	"github.com/coreos/go-semver 568e959cd89871e61434c1143528d9162da89ef2"
	"github.com/projectcalico/go-yaml 955bc3e451ef0c9df8b9113bf2e341139cdafab2"
	"github.com/satori/go.uuid 879c5887cd475cd7864858769793b2ceb0d44feb"
	"github.com/sirupsen/logrus ba1b36c82c5e05c4f912a88eab0dcd91a171688f"
	"github.com/spf13/viper 25b30aa063fc18e48662b86996252eabdcf2f0c7"
	"github.com/fsnotify/fsnotify 4da3e2cfbabc9f751898f250b49f2439785783a1"
	"github.com/hashicorp/hcl 392dba7d905ed5d04a5794ba89f558b27e2ba1ca"
	"github.com/magiconair/properties be5ece7dd465ab0765a9682137865547526d1dfb"
	"github.com/mitchellh/mapstructure d0303fe809921458f417bcf828397a65db30a7e4"
	"github.com/pelletier/go-toml 69d355db5304c0f7f809a2edc054553e7142f016"
	"github.com/spf13/afero 9be650865eab0c12963d8753212f4f9c66cdcf12"
	"github.com/spf13/cast acbeb36b902d72a7a4c18e8f3241075e7ab763e4"
	"github.com/spf13/jwalterweatherman 0efa5202c04663c757d84f90f5219c1250baf94f"
	"github.com/spf13/pflag 08b1a584251b5b62f458943640fc8ebd4d50aaa5"
	"github.com/termie/go-shutil bcacb06fecaeec8dc42af03c87c6949f4a05c74c"
	"github.com/ugorji/go ded73eae5db7e7a0ef6f55aace87a2873c5d2b74"
	"github.com/vishvananda/netlink f5a6f697a596c788d474984a38a0ac4ba0719e93"
	"github.com/vishvananda/netns 8ba1072b58e0c2a240eb5f6120165c7776c3e7b8"
	"golang.org/x/net f2499483f923065a842d38eb4c7f1927e6fc6e6d github.com/golang/net"
	"golang.org/x/sys 8f0908ab3b2457e2e15403d3697c9ef5cb4b57a9 github.com/golang/sys"
	"golang.org/x/text 19e51611da83d6be54ddafce4a4af510cb3e9ea4 github.com/golang/text"
	"github.com/golang/glog 44145f04b68cf362d9c4df2182967c2275eaefed"
	"google.golang.org/grpc 777daa17ff9b5daef1cfdf915088a2ada3332bf0 github.com/grpc/grpc-go"
	"gopkg.in/go-playground/validator.v8 5f57d2222ad794d0dffb07e664ea05e2ee07d60c github.com/go-playground/validator"
	"gopkg.in/tchap/go-patricia.v2 666120de432aea38ab06bd5c818f04f4129882c9 github.com/tchap/go-patricia"
	"gopkg.in/tomb.v2 d5d1b5820637886def9eef33e03a27a9f166942c github.com/go-tomb/tomb"
	"gopkg.in/yaml.v2 53feefa2559fb8dfa8d81baad31be332c97d6c77 github.com/go-yaml/yaml"
	"k8s.io/client-go 4a3ab2f5be5177366f8206fd79ce55ca80e417fa github.com/kubernetes/client-go"
	"k8s.io/apimachinery b317fa7ec8e0e7d1f77ac63bf8c3ec7b29a2a215 github.com/kubernetes/apimachinery")

inherit golang-vcs-snapshot

CALICOCTL_COMMIT="118b8ae1cbfb852f387c9066b5ae27633593a99f"

KEYWORDS="~amd64"
DESCRIPTION="CLI to manage Calico network and security policy"
EGO_PN="github.com/projectcalico/calicoctl"
HOMEPAGE="https://github.com/projectcalico/calicoctl"
MY_PV=${PV/_/-}
SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd "src/${EGO_PN}" || die
	GOPATH="${WORKDIR}/${P}" CGO_ENABLED=0 go build -v -o dist/calicoctl -ldflags \
		"-X github.com/projectcalico/calicoctl/calicoctl/commands.VERSION=${PV} \
		-X github.com/projectcalico/calicoctl/calicoctl/commands.BUILD_DATE=$(date -u +'%FT%T%z') \
		-X github.com/projectcalico/calicoctl/calicoctl/commands.GIT_REVISION=${CALICOCTL_COMMIT}" "./calicoctl/calicoctl.go" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin "dist/${PN}"
	dodoc README.md
}
