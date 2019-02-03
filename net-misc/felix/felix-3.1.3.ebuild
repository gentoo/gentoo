# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
"cloud.google.com/go 3b1ae45394a234c385be014e9a488f2bb6eef821 github.com/GoogleCloudPlatform/gcloud-golang"
"github.com/Azure/go-autorest 58f6f26e200fa5dfb40c9cd1c83f3e2c860d779d"
"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
"github.com/containernetworking/cni 137b4975ecab6e1f0c24c1e3c228a50a3cfba75e"
"github.com/coreos/etcd c23606781f63d09917a1e7abfcefeb337a9608ea"
"github.com/davecgh/go-spew 782f4967f2dc4564575ca782fe2d04090b5faca8"
"github.com/dgrijalva/jwt-go 01aeca54ebda6e0fbfafd0a524d234159c05ec20"
"github.com/docopt/docopt-go 784ddc588536785e7299f7272f39101f7faccc3f"
"github.com/emicklei/go-restful 777bb3f19bcafe2575ffb2a3e46af92509ae9594"
"github.com/emicklei/go-restful-swagger12 dcef7f55730566d41eae5db10e7d6981829720f6"
"github.com/ghodss/yaml 0ca9ea5df5451ffdf184b4428c902747c2c11cd7"
"github.com/go-ini/ini 06f5f3d67269ccec1fe5fe4134ba6e982984f7f5"
"github.com/go-openapi/jsonpointer 46af16f9f7b149af66e5d1bd010e3574dc06de98"
"github.com/go-openapi/jsonreference 13c6e3589ad90f49bd3e3bbe2c2cb3d7a4142272"
"github.com/go-openapi/spec 6aced65f8501fe1217321abf0749d354824ba2ff"
"github.com/go-openapi/swag 1d0bd113de87027671077d3c71eb3ac5d7dbba72"
"github.com/gogo/protobuf 342cbe0a04158f6dcb03ca0079991a51a4248c02"
"github.com/golang/glog 44145f04b68cf362d9c4df2182967c2275eaefed"
"github.com/golang/protobuf 4bd1920723d7b7c925de087aa32e2187708897f7"
"github.com/google/btree 7d79101e329e5a3adf994758c578dab82b90c017"
"github.com/google/gofuzz 44d81051d367757e1c7c6a5a86423ece9afcf63c"
"github.com/googleapis/gnostic 0c5108395e2debce0d731cf0287ddf7242066aba"
"github.com/gophercloud/gophercloud 2bf16b94fdd9b01557c4d076e567fe5cbbe5a961"
"github.com/gregjones/httpcache 787624de3eb7bd915c329cba748687a3b22666a6"
"github.com/gxed/eventfd 80a92cca79a8041496ccc9dd773fcb52a57ec6f9"
"github.com/gxed/GoEndian 0f5c6873267e5abf306ffcdfcfa4bf77517ef4a7"
"github.com/hashicorp/golang-lru a0d98a5f288019575c6d1f4bb1573fef2d1fcdc4"
"github.com/howeyc/gopass bf9dde6d0d2c004a008c27aaee91170c786f6db8"
"github.com/imdario/mergo 6633656539c1639d9d78127b7d47c622b5d7b6dc"
"github.com/ipfs/go-log b9df188d0fae32d69c1a519fa81741668a12f55a"
"github.com/jbenet/go-reuseport 7eed93a5b50b20c209baefe9fafa53c3d965a33c"
"github.com/jbenet/go-sockaddr 2e7ea655c10e4d4d73365f0f073b81b39cb08ee1"
"github.com/json-iterator/go 36b14963da70d11297d313183d7e6388c8510e1e"
"github.com/juju/ratelimit 5b9ff866471762aa2ab2dced63c9fb6f53921342"
"github.com/kardianos/osext ae77be60afb1dcacde03767a8c37337fad28ac14"
"github.com/kelseyhightower/envconfig f611eb38b3875cc3bd991ca91c51d06446afa14c"
"github.com/mailru/easyjson d5b7844b561a7bc640052f1b935f7b800330d7e0"
"github.com/mattn/go-colorable efa589957cd060542a26d2dd7832fd6a6c6c3ade"
"github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
"github.com/matttproud/golang_protobuf_extensions fc2b8d3a73c4867e51861bbdd5ae3c1f0869dd6a"
"github.com/Microsoft/go-winio 78439966b38d69bf38227fbf57ac8a6fee70f69a"
"github.com/Microsoft/hcsshim 34a629f78a5d50f7de07727e41a948685c45e026"
"github.com/mipearson/rfw 6f0a6f3266ba1058df9ef0c94cda1cecd2e62852"
"github.com/onsi/ginkgo fa5fabab2a1bfbd924faf4c067d07ae414e2aedf"
"github.com/onsi/gomega 62bff4df71bdbc266561a0caee19f0594b17c240"
"github.com/opentracing/opentracing-go 6c572c00d1830223701e155de97408483dfcd14a"
"github.com/pborman/uuid ca53cad383cad2479bbba7f7a1a05797ec1386e4"
"github.com/peterbourgon/diskv 5f041e8faa004a95c88a202771f4cc3e991971e6"
"github.com/projectcalico/go-json 6219dc7339ba20ee4c57df0a8baac62317d19cb1"
"github.com/projectcalico/go-yaml 955bc3e451ef0c9df8b9113bf2e341139cdafab2"
"github.com/projectcalico/go-yaml-wrapper 598e54215bee41a19677faa4f0c32acd2a87eb56"
"github.com/projectcalico/libcalico-go 0417ab6e1ea49be2abb978df365b25f20fdb3c6f"
"github.com/projectcalico/typha 5374e9f32bde159a4aa19c821618920f491004be"
"github.com/prometheus/client_golang 967789050ba94deca04a5e84cce8ad472ce313c1"
"github.com/prometheus/client_model 6f3806018612930941127f2a7c6c453ba2c527d2"
"github.com/prometheus/common 7600349dcfe1abd18d72d3a1770870d9800a7801"
"github.com/prometheus/procfs f98634e408857669d61064b283c4cde240622865"
"github.com/PuerkitoBio/purell 8a290539e2e8629dbc4e6bad948158f790ec31f4"
"github.com/PuerkitoBio/urlesc 5bd2802263f21d8788851d5305584c82a5c75d7e"
"github.com/satori/go.uuid f58768cc1a7a7e77a3bd49e98cdd21419399b6a3"
"github.com/sirupsen/logrus d682213848ed68c0a260ca37d6dd5ace8423f5ba"
"github.com/spf13/pflag 9ff6c6923cfffbcd502984b8e0c80539a94968b7"
"github.com/vishvananda/netlink dc00cf9d5c07f9a1e0ccb307443b2194ca1aaacb"
"github.com/vishvananda/netns 8ba1072b58e0c2a240eb5f6120165c7776c3e7b8"
"github.com/whyrusleeping/go-logging 0457bb6b88fc1973573aaf6b5145d8d3ae972390"
"golang.org/x/crypto ab813273cd59e1333f7ae7bff5d027d4aadf528c github.com/golang/crypto"
"golang.org/x/net 66aacef3dd8a676686c7ae3716979581e8b03c47 github.com/golang/net"
"golang.org/x/oauth2 a6bd8cefa1811bd24b86f8902872e4e8225f74c4 github.com/golang/oauth2"
"golang.org/x/sys 88d2dcc510266da9f7f8c7f34e1940716cab5f5c github.com/golang/sys"
"golang.org/x/text 4ee4af566555f5fbe026368b75596286a312663a github.com/golang/text"
"google.golang.org/appengine b1f26356af11148e710935ed1ac8a7f5702c7612 github.com/golang/appengine"
"google.golang.org/genproto 09f6ed296fc66555a25fe4ce95173148778dfa85 github.com/google/go-genproto"
"google.golang.org/grpc 5b3c4e850e90a4cf6a20ebd46c8b32a0a3afcb9e github.com/grpc/grpc-go"
"gopkg.in/go-playground/validator.v8 5f57d2222ad794d0dffb07e664ea05e2ee07d60c github.com/go-playground/validator"
"gopkg.in/inf.v0 3887ee99ecf07df5b447e9b00d9c0b2adaa9f3e4 github.com/go-inf/inf"
"gopkg.in/yaml.v2 53feefa2559fb8dfa8d81baad31be332c97d6c77 github.com/go-yaml/yaml"
"k8s.io/api a315a049e7a93e5455f7fefce1ba136d85054687 github.com/kubernetes/api"
"k8s.io/apimachinery 40eaf68ee1889b1da1c528b1a075ecfe94e66837 github.com/kubernetes/apimachinery"
"k8s.io/client-go 82aa063804cf055e16e8911250f888bc216e8b61 github.com/kubernetes/client-go"
"k8s.io/kube-openapi 0c329704159e3b051aafac400b15baacf2a94a04 github.com/kubernetes/kube-openapi"
)

inherit golang-vcs-snapshot systemd user

FELIX_COMMIT="dba3279377fd6ec7baf0ee560bcaec685f25fa86"

KEYWORDS="~amd64"
DESCRIPTION="Calico's per-host agent, responsible for programming routes and security policy"
EGO_PN="github.com/projectcalico/felix"
HOMEPAGE="https://github.com/projectcalico/felix"
SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="+bird"

RESTRICT="test"

DEPEND=">=dev-libs/protobuf-3
	dev-go/gogo-protobuf"

RDEPEND="net-firewall/ipset
	bird? ( net-misc/bird )"

src_compile() {
	pushd "src/${EGO_PN}" || die
	protoc --gogofaster_out=plugins=grpc:. proto/*.proto || die
	GOPATH="${WORKDIR}/${P}" CGO_ENABLED=0 go build -v -o bin/calico-felix -ldflags \
		"-X github.com/projectcalico/felix/buildinfo.GitVersion=${PV} \
		-X github.com/projectcalico/felix/buildinfo.BuildDate=$(date -u +'%FT%T%z') \
		-X github.com/projectcalico/felix/buildinfo.GitRevision=${FELIX_COMMIT}" "github.com/projectcalico/felix" || die
	popd || die
}

src_install() {
	pushd "src/${EGO_PN}" || die
	dobin "bin/calico-${PN}"
	dodoc README.md
	insinto /etc/logrotate.d
	doins debian/calico-felix.logrotate
	insinto /etc/felix
	doins etc/felix.cfg.example
	newinitd "${FILESDIR}"/felix.initd felix
	newconfd "${FILESDIR}"/felix.confd felix
}
