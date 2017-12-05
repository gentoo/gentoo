# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="k8s.io/helm"

EGO_VENDOR=(
"cloud.google.com/go 3b1ae45394a234c385be014e9a488f2bb6eef821 github.com/GoogleCloudPlatform/gcloud-golang"
"github.com/aokoli/goutils 9c37978a95bd5c709a15883b6242714ea6709e64"
"github.com/asaskevich/govalidator 7664702784775e51966f0885f5cd27435916517b"
"github.com/Azure/go-autorest 58f6f26e200fa5dfb40c9cd1c83f3e2c860d779d"
"github.com/beorn7/perks 3ac7bf7a47d159a033b107610db8a1b6575507a4"
"github.com/BurntSushi/toml b26d9c308763d68093482582cea63d69be07a0f0"
"github.com/chai2010/gettext-go bf70f2a70fb1b1f36d90d671a72795984eab0fcb"
"github.com/cpuguy83/go-md2man 71acacd42f85e5e82f70a55327789582a5200a90"
"github.com/davecgh/go-spew 782f4967f2dc4564575ca782fe2d04090b5faca8"
"github.com/dgrijalva/jwt-go 01aeca54ebda6e0fbfafd0a524d234159c05ec20"
"github.com/docker/distribution edc3ab29cdff8694dd6feb85cfeb4b5f1b38ed9c"
"github.com/docker/docker 4f3616fb1c112e206b88cb7a9922bf49067a7756"
"github.com/docker/go-connections 3ede32e2033de7505e6500d6c868c2b9ed9f169d"
"github.com/docker/go-units 9e638d38cf6977a37a8ea0078f3ee75a7cdb2dd1"
"github.com/docker/spdystream 449fdfce4d962303d702fec724ef0ad181c92528"
"github.com/emicklei/go-restful ff4f55a206334ef123e4f79bbf348980da81ca46"
"github.com/emicklei/go-restful-swagger12 dcef7f55730566d41eae5db10e7d6981829720f6"
"github.com/evanphx/json-patch 944e07253867aacae43c04b2e6a239005443f33a"
"github.com/exponent-io/jsonpath d6023ce2651d8eafb5c75bb0c7167536102ec9f5"
"github.com/fatih/camelcase f6a740d52f961c60348ebb109adde9f4635d7540"
"github.com/ghodss/yaml 73d445a93680fa1a78ae23a5839bad48f32ba1ee"
"github.com/go-openapi/jsonpointer 46af16f9f7b149af66e5d1bd010e3574dc06de98"
"github.com/go-openapi/jsonreference 13c6e3589ad90f49bd3e3bbe2c2cb3d7a4142272"
"github.com/go-openapi/spec 6aced65f8501fe1217321abf0749d354824ba2ff"
"github.com/go-openapi/swag 1d0bd113de87027671077d3c71eb3ac5d7dbba72"
"github.com/gobwas/glob bea32b9cd2d6f55753d94a28e959b13f0244797a"
"github.com/gogo/protobuf c0656edd0d9eab7c66d1eb0c568f9039345796f7"
"github.com/golang/glog 44145f04b68cf362d9c4df2182967c2275eaefed"
"github.com/golang/groupcache 02826c3e79038b59d737d3b1c0a1d937f71a4433"
"github.com/golang/protobuf 4bd1920723d7b7c925de087aa32e2187708897f7"
"github.com/google/btree 7d79101e329e5a3adf994758c578dab82b90c017"
"github.com/google/gofuzz 44d81051d367757e1c7c6a5a86423ece9afcf63c"
"github.com/googleapis/gnostic 0c5108395e2debce0d731cf0287ddf7242066aba"
"github.com/gophercloud/gophercloud 2bf16b94fdd9b01557c4d076e567fe5cbbe5a961"
"github.com/gosuri/uitable 36ee7e946282a3fb1cfecd476ddc9b35d8847e42"
"github.com/gregjones/httpcache 787624de3eb7bd915c329cba748687a3b22666a6"
"github.com/grpc-ecosystem/go-grpc-prometheus 0c1b191dbfe51efdabe3c14b9f6f3b96429e0722"
"github.com/hashicorp/golang-lru a0d98a5f288019575c6d1f4bb1573fef2d1fcdc4"
"github.com/howeyc/gopass bf9dde6d0d2c004a008c27aaee91170c786f6db8"
"github.com/huandu/xstrings 3959339b333561bf62a38b424fd41517c2c90f40"
"github.com/imdario/mergo 6633656539c1639d9d78127b7d47c622b5d7b6dc"
"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
"github.com/json-iterator/go 36b14963da70d11297d313183d7e6388c8510e1e"
"github.com/juju/ratelimit 5b9ff866471762aa2ab2dced63c9fb6f53921342"
"github.com/mailru/easyjson d5b7844b561a7bc640052f1b935f7b800330d7e0"
"github.com/Masterminds/semver 517734cc7d6470c0d07130e40fd40bdeb9bcd3fd"
"github.com/Masterminds/sprig efda631a76d70875162cdc25ffa0d0164bf69758"
"github.com/Masterminds/vcs 3084677c2c188840777bff30054f2b553729d329"
"github.com/mattn/go-runewidth d6bea18f789704b5f83375793155289da36a3c7f"
"github.com/matttproud/golang_protobuf_extensions fc2b8d3a73c4867e51861bbdd5ae3c1f0869dd6a"
"github.com/naoina/go-stringutil 6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
"github.com/opencontainers/go-digest a6d0ee40d4207ea02364bd3b9e8e77b9159ba1eb"
"github.com/opencontainers/image-spec 372ad780f63454fbbbbcc7cf80e5b90245c13e13"
"github.com/pborman/uuid ca53cad383cad2479bbba7f7a1a05797ec1386e4"
"github.com/peterbourgon/diskv 5f041e8faa004a95c88a202771f4cc3e991971e6"
"github.com/prometheus/client_golang c5b7fccd204277076155f10851dad72b76a49317"
"github.com/prometheus/client_model fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
"github.com/prometheus/common 13ba4ddd0caa9c28ca7b7bffe1dfa9ed8d5ef207"
"github.com/prometheus/procfs 65c1f6f8f0fc1e2185eb9863a3bc751496404259"
"github.com/PuerkitoBio/purell 8a290539e2e8629dbc4e6bad948158f790ec31f4"
"github.com/PuerkitoBio/urlesc 5bd2802263f21d8788851d5305584c82a5c75d7e"
"github.com/russross/blackfriday 300106c228d52c8941d4b3de6054a6062a86dda3"
"github.com/satori/go.uuid 879c5887cd475cd7864858769793b2ceb0d44feb"
"github.com/shurcooL/sanitized_anchor_name 10ef21a441db47d8b13ebcc5fd2310f636973c77"
"github.com/spf13/cobra f62e98d28ab7ad31d707ba837a966378465c7b57"
"github.com/spf13/pflag 9ff6c6923cfffbcd502984b8e0c80539a94968b7"
"github.com/technosophos/moniker ab470f5e105a44d0c87ea21bacd6a335c4816d83"
"github.com/ugorji/go ded73eae5db7e7a0ef6f55aace87a2873c5d2b74"
"golang.org/x/crypto 81e90905daefcd6fd217b62423c0908922eadb30 github.com/golang/crypto"
"golang.org/x/net 1c05540f6879653db88113bc4a2b70aec4bd491f github.com/golang/net"
"golang.org/x/oauth2 a6bd8cefa1811bd24b86f8902872e4e8225f74c4 github.com/golang/oauth2"
"golang.org/x/sys 43eea11bc92608addb41b8a406b0407495c106f6 github.com/golang/sys"
"golang.org/x/text b19bf474d317b857955b12035d2c5acb57ce8b01 github.com/golang/text"
"google.golang.org/appengine 12d5545dc1cfa6047a286d5e853841b6471f4c19 github.com/golang/appengine"
"google.golang.org/genproto 09f6ed296fc66555a25fe4ce95173148778dfa85 github.com/google/go-genproto"
"google.golang.org/grpc 8050b9cbc271307e5a716a9d782803d09b0d6f2d github.com/grpc/grpc-go"
"gopkg.in/inf.v0 3887ee99ecf07df5b447e9b00d9c0b2adaa9f3e4 github.com/go-inf/inf"
"gopkg.in/yaml.v2 53feefa2559fb8dfa8d81baad31be332c97d6c77 github.com/go-yaml/yaml"
"k8s.io/api cadaf100c0a3dd6b254f320d6d651df079ec8e0a github.com/kubernetes/api"
"k8s.io/apiextensions-apiserver a5bbfd114a9b122acd741c61d88c84812375d9e1 github.com/kubernetes/apiextensions-apiserver"
"k8s.io/apimachinery 3b05bbfa0a45413bfa184edbf9af617e277962fb github.com/kubernetes/apimachinery"
"k8s.io/apiserver c1e53d745d0fe45bf7d5d44697e6eface25fceca github.com/kubernetes/apiserver"
"k8s.io/client-go 82aa063804cf055e16e8911250f888bc216e8b61 github.com/kubernetes/client-go"
"k8s.io/kube-openapi 868f2f29720b192240e18284659231b440f9cda5 github.com/kubernetes/kube-openapi"
"k8s.io/kubernetes 0b9efaeb34a2fc51ff8e4d34ad9bc6375459c4a4 github.com/kubernetes/kubernetes"
"k8s.io/metrics 8efbc8e22d00b9c600afec5f1c14073fd2412fce github.com/kubernetes/metrics"
"k8s.io/utils 9fdc871a36f37980dd85f96d576b20d564cc0784 github.com/kubernetes/utils"
"vbom.ml/util db5cfe13f5cc80a4990d98e2e1b0707a4d1a5394 github.com/fvbommel/util"
)
inherit golang-build golang-vcs-snapshot bash-completion-r1

GIT_COMMIT="04769b7c26109aabfc9c6b645b345d665b6bd0cd"

ARCHIVE_URI="https://github.com/kubernetes/helm/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://github.com/kubernetes/helm https://helm.sh"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_prepare() {
	default
	sed -i -e "s/git rev-parse HEAD/echo ${GIT_COMMIT}/"\
		-e "s/git rev-parse --short HEAD/echo ${GIT_COMMIT:0:7}/"\
		-e "s#git describe --tags --abbrev=0 --exact-match 2>/dev/null#echo ${PV}#"\
		-e 's/test -n "`git status --porcelain`" && echo "dirty" ||//' src/${EGO_PN}/versioning.mk || die

	rm -rf src/${EGO_PN}/vendor/*/*/vendor src/${EGO_PN}/vendor/*/*/*/vendor  || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -o bin/protoc-gen-go ./vendor/github.com/golang/protobuf/protoc-gen-go || die
	./scripts/setup-apimachinery.sh || die
	GOBINDIR="$(pwd)/bin" GOPATH="${S}"\
	go install -v -ldflags "-X k8s.io/helm/pkg/version.Version=${PV} -X k8s.io/helm/pkg/version.BuildMetadata= -X k8s.io/helm/pkg/version.GitCommit=${GIT_COMMIT} -X k8s.io/helm/pkg/version.GitTreeState=clean" k8s.io/helm/cmd/... || die
	popd || die
	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
}

src_install() {
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}

	dobin bin/${PN}
	dodoc src/${EGO_PN}/README.md
}
