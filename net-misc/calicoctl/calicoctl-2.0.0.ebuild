# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
"cloud.google.com/go 3b1ae45394a234c385be014e9a488f2bb6eef821 github.com/GoogleCloudPlatform/gcloud-golang"
"github.com/armon/go-radix 1fca145dffbcaa8fe914309b1ec0cfc67500fe61"
"github.com/Azure/go-autorest 58f6f26e200fa5dfb40c9cd1c83f3e2c860d779d"
"github.com/beorn7/perks 3ac7bf7a47d159a033b107610db8a1b6575507a4"
"github.com/coreos/etcd bb66589f8cf18960c7f3d56b1b83753caeed9c7a"
"github.com/davecgh/go-spew 782f4967f2dc4564575ca782fe2d04090b5faca8"
"github.com/dgrijalva/jwt-go d2709f9f1f31ebcda9651b03077758c1f3a0018c"
"github.com/docopt/docopt-go 784ddc588536785e7299f7272f39101f7faccc3f"
"github.com/eapache/channels 47238d5aae8c0fefd518ef2bee46290909cf8263"
"github.com/eapache/queue 44cc805cf13205b55f69e14bcb69867d1ae92f98"
"github.com/emicklei/go-restful ff4f55a206334ef123e4f79bbf348980da81ca46"
"github.com/emicklei/go-restful-swagger12 dcef7f55730566d41eae5db10e7d6981829720f6"
"github.com/fsnotify/fsnotify 4da3e2cfbabc9f751898f250b49f2439785783a1"
"github.com/ghodss/yaml 73d445a93680fa1a78ae23a5839bad48f32ba1ee"
"github.com/go-openapi/jsonpointer 46af16f9f7b149af66e5d1bd010e3574dc06de98"
"github.com/go-openapi/jsonreference 13c6e3589ad90f49bd3e3bbe2c2cb3d7a4142272"
"github.com/go-openapi/spec 6aced65f8501fe1217321abf0749d354824ba2ff"
"github.com/go-openapi/swag 1d0bd113de87027671077d3c71eb3ac5d7dbba72"
"github.com/gogo/protobuf c0656edd0d9eab7c66d1eb0c568f9039345796f7"
"github.com/golang/glog 44145f04b68cf362d9c4df2182967c2275eaefed"
"github.com/golang/protobuf 4bd1920723d7b7c925de087aa32e2187708897f7"
"github.com/google/btree 925471ac9e2131377a91e1595defec898166fe49"
"github.com/google/gofuzz 44d81051d367757e1c7c6a5a86423ece9afcf63c"
"github.com/googleapis/gnostic 68f4ded48ba9414dab2ae69b3f0d69971da73aa5"
"github.com/gophercloud/gophercloud 2bf16b94fdd9b01557c4d076e567fe5cbbe5a961"
"github.com/gregjones/httpcache 787624de3eb7bd915c329cba748687a3b22666a6"
"github.com/hashicorp/golang-lru a0d98a5f288019575c6d1f4bb1573fef2d1fcdc4"
"github.com/hashicorp/hcl 23c074d0eceb2b8a5bfdbb271ab780cde70f05a8"
"github.com/howeyc/gopass bf9dde6d0d2c004a008c27aaee91170c786f6db8"
"github.com/imdario/mergo 6633656539c1639d9d78127b7d47c622b5d7b6dc"
"github.com/influxdata/influxdb b287c191f362e7313aae0fa08c19b787076ad530"
"github.com/json-iterator/go 36b14963da70d11297d313183d7e6388c8510e1e"
"github.com/juju/ratelimit 5b9ff866471762aa2ab2dced63c9fb6f53921342"
"github.com/kelseyhightower/envconfig f611eb38b3875cc3bd991ca91c51d06446afa14c"
"github.com/magiconair/properties 49d762b9817ba1c2e9d0c69183c2b4a8b8f1d934"
"github.com/mailru/easyjson d5b7844b561a7bc640052f1b935f7b800330d7e0"
"github.com/mattn/go-runewidth 97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
"github.com/matttproud/golang_protobuf_extensions fc2b8d3a73c4867e51861bbdd5ae3c1f0869dd6a"
"github.com/mcuadros/go-version 88e56e02bea1c203c99222c365fa52a69996ccac"
"github.com/mitchellh/go-ps 4fdf99ab29366514c69ccccddab5dc58b8d84062"
"github.com/mitchellh/mapstructure 06020f85339e21b2478f756a78e295255ffa4d6a"
"github.com/olekukonko/tablewriter 65fec0d89a572b4367094e2058d3ebe667de3b60"
"github.com/onsi/ginkgo 9eda700730cba42af70d53180f9dcce9266bc2bc"
"github.com/onsi/gomega c893efa28eb45626cdaa76c9f653b62488858837"
"github.com/osrg/gobgp bbd1d99396fef6503e308d1851ecf91c31006635"
"github.com/pborman/uuid ca53cad383cad2479bbba7f7a1a05797ec1386e4"
"github.com/pelletier/go-toml b8b5e7696574464b2f9bf303a7b37781bb52889f"
"github.com/peterbourgon/diskv 5f041e8faa004a95c88a202771f4cc3e991971e6"
"github.com/projectcalico/go-json 6219dc7339ba20ee4c57df0a8baac62317d19cb1"
"github.com/projectcalico/go-yaml 955bc3e451ef0c9df8b9113bf2e341139cdafab2"
"github.com/projectcalico/go-yaml-wrapper 598e54215bee41a19677faa4f0c32acd2a87eb56"
"github.com/projectcalico/libcalico-go 7c2de5ed8c029f222d87fc849b54c4075ef3173f"
"github.com/prometheus/client_golang 967789050ba94deca04a5e84cce8ad472ce313c1"
"github.com/prometheus/client_model fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
"github.com/prometheus/common 49fee292b27bfff7f354ee0f64e1bc4850462edf"
"github.com/prometheus/procfs a1dba9ce8baed984a2495b658c82687f8157b98f"
"github.com/PuerkitoBio/purell 8a290539e2e8629dbc4e6bad948158f790ec31f4"
"github.com/PuerkitoBio/urlesc 5bd2802263f21d8788851d5305584c82a5c75d7e"
"github.com/satori/go.uuid 879c5887cd475cd7864858769793b2ceb0d44feb"
"github.com/sirupsen/logrus d682213848ed68c0a260ca37d6dd5ace8423f5ba"
"github.com/spf13/afero 8d919cbe7e2627e417f3e45c3c0e489a5b7e2536"
"github.com/spf13/cast acbeb36b902d72a7a4c18e8f3241075e7ab763e4"
"github.com/spf13/jwalterweatherman 12bd96e66386c1960ab0f74ced1362f66f552f7b"
"github.com/spf13/pflag 9ff6c6923cfffbcd502984b8e0c80539a94968b7"
"github.com/spf13/viper 1a0c4a370c3e8286b835467d2dfcdaf636c3538b"
"github.com/termie/go-shutil bcacb06fecaeec8dc42af03c87c6949f4a05c74c"
"github.com/vishvananda/netlink fe3b5664d23a11b52ba59bece4ff29c52772a56b"
"github.com/vishvananda/netns 8ba1072b58e0c2a240eb5f6120165c7776c3e7b8"
"golang.org/x/crypto 9419663f5a44be8b34ca85f08abc5fe1be11f8a3 github.com/golang/crypto"
"golang.org/x/net 1c05540f6879653db88113bc4a2b70aec4bd491f github.com/golang/net"
"golang.org/x/oauth2 a6bd8cefa1811bd24b86f8902872e4e8225f74c4 github.com/golang/oauth2"
"golang.org/x/sys 314a259e304ff91bd6985da2a7149bbf91237993 github.com/golang/sys"
"golang.org/x/text b19bf474d317b857955b12035d2c5acb57ce8b01 github.com/golang/text"
"google.golang.org/appengine 5bee14b453b4c71be47ec1781b0fa61c2ea182db github.com/golang/appengine"
"google.golang.org/grpc 8050b9cbc271307e5a716a9d782803d09b0d6f2d github.com/grpc/grpc-go"
"gopkg.in/go-playground/validator.v8 5f57d2222ad794d0dffb07e664ea05e2ee07d60c github.com/go-playground/validator"
"gopkg.in/inf.v0 3887ee99ecf07df5b447e9b00d9c0b2adaa9f3e4 github.com/go-inf/inf"
"gopkg.in/tomb.v2 d5d1b5820637886def9eef33e03a27a9f166942c github.com/go-tomb/tomb"
"gopkg.in/yaml.v2 53feefa2559fb8dfa8d81baad31be332c97d6c77 github.com/go-yaml/yaml"
"k8s.io/api 9b9dca205a15b6ce9ef10091f05d60a13fdcf418 github.com/kubernetes/api"
"k8s.io/apimachinery 5134afd2c0c91158afac0d8a28bd2177185a3bcc github.com/kubernetes/apimachinery"
"k8s.io/client-go 82aa063804cf055e16e8911250f888bc216e8b61 github.com/kubernetes/client-go"
"k8s.io/kube-openapi 868f2f29720b192240e18284659231b440f9cda5 github.com/kubernetes/kube-openapi"
)

inherit golang-vcs-snapshot

CALICOCTL_COMMIT="8006d58068c2a81d23977670e0c6061d959ba32c"

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
