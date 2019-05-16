# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="k8s.io/helm"

MY_PV=${PV/_rc/-rc.}

EGO_VENDOR=(
"cloud.google.com/go 3b1ae45394a234c385be014e9a488f2bb6eef821 github.com/GoogleCloudPlatform/gcloud-golang"
"github.com/asaskevich/govalidator 7664702784775e51966f0885f5cd27435916517b"
"github.com/Azure/go-ansiterm d6e3b3328b783f23731bc4d058875b0371ff8109"
"github.com/Azure/go-autorest ea233b6412b0421a65dc6160e16c893364664a95"
"github.com/beorn7/perks 3ac7bf7a47d159a033b107610db8a1b6575507a4"
"github.com/BurntSushi/toml 3012a1dbe2e4bd1391d42b32f0577cb7bbc7f005"
"github.com/chai2010/gettext-go c6fed771bfd517099caf0f7a961671fa8ed08723"
"github.com/cpuguy83/go-md2man 71acacd42f85e5e82f70a55327789582a5200a90"
"github.com/cyphar/filepath-securejoin a261ee33d7a517f054effbf451841abaafe3e0fd"
"github.com/davecgh/go-spew 782f4967f2dc4564575ca782fe2d04090b5faca8"
"github.com/dgrijalva/jwt-go 01aeca54ebda6e0fbfafd0a524d234159c05ec20"
"github.com/docker/distribution edc3ab29cdff8694dd6feb85cfeb4b5f1b38ed9c"
"github.com/docker/docker a9fbbdc8dd8794b20af358382ab780559bca589d"
"github.com/docker/go-units 9e638d38cf6977a37a8ea0078f3ee75a7cdb2dd1"
"github.com/docker/spdystream 449fdfce4d962303d702fec724ef0ad181c92528"
"github.com/evanphx/json-patch 36442dbdb585210f8d5a1b45e67aa323c197d5c4"
"github.com/exponent-io/jsonpath d6023ce2651d8eafb5c75bb0c7167536102ec9f5"
"github.com/fatih/camelcase f6a740d52f961c60348ebb109adde9f4635d7540"
"github.com/ghodss/yaml 73d445a93680fa1a78ae23a5839bad48f32ba1ee"
"github.com/go-openapi/jsonpointer ef5f0afec364d3b9396b7b77b43dbe26bf1f8004"
"github.com/go-openapi/jsonreference 8483a886a90412cd6858df4ea3483dce9c8e35a3"
"github.com/go-openapi/spec 5bae59e25b21498baea7f9d46e9c147ec106a42e"
"github.com/go-openapi/swag 5899d5c5e619fda5fa86e14795a835f473ca284c"
"github.com/gobwas/glob 5ccd90ef52e1e632236f7326478d4faa74f99438"
"github.com/gogo/protobuf 342cbe0a04158f6dcb03ca0079991a51a4248c02"
"github.com/golang/glog 44145f04b68cf362d9c4df2182967c2275eaefed"
"github.com/golang/groupcache 02826c3e79038b59d737d3b1c0a1d937f71a4433"
"github.com/golang/protobuf aa810b61a9c79d51363740d207bb46cf8e620ed5"
"github.com/google/btree 7d79101e329e5a3adf994758c578dab82b90c017"
"github.com/google/gofuzz 44d81051d367757e1c7c6a5a86423ece9afcf63c"
"github.com/google/uuid 064e2069ce9c359c118179501254f67d7d37ba24"
"github.com/googleapis/gnostic 0c5108395e2debce0d731cf0287ddf7242066aba"
"github.com/gophercloud/gophercloud 781450b3c4fcb4f5182bcc5133adb4b2e4a09d1d"
"github.com/gosuri/uitable 36ee7e946282a3fb1cfecd476ddc9b35d8847e42"
"github.com/gregjones/httpcache 787624de3eb7bd915c329cba748687a3b22666a6"
"github.com/grpc-ecosystem/go-grpc-prometheus 0c1b191dbfe51efdabe3c14b9f6f3b96429e0722"
"github.com/hashicorp/golang-lru a0d98a5f288019575c6d1f4bb1573fef2d1fcdc4"
"github.com/huandu/xstrings f02667b379e2fb5916c3cda2cf31e0eb885d79f8"
"github.com/imdario/mergo 9316a62528ac99aaecb4e47eadd6dc8aa6533d58"
"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
"github.com/json-iterator/go ab8a2e0c74be9d3be70b3184d9acc634935ded82"
"github.com/mailru/easyjson 2f5df55504ebc322e4d52d34df6a1f5b503bf26d"
"github.com/MakeNowJust/heredoc bb23615498cded5e105af4ce27de75b089cbe851"
"github.com/Masterminds/goutils 41ac8693c5c10a92ea1ff5ac3a7f95646f6123b0"
"github.com/Masterminds/semver 517734cc7d6470c0d07130e40fd40bdeb9bcd3fd"
"github.com/Masterminds/sprig b1fe2752acccf8c3d7f8a1e7c75c7ae7d83a1975"
"github.com/Masterminds/vcs 3084677c2c188840777bff30054f2b553729d329"
"github.com/mattn/go-runewidth d6bea18f789704b5f83375793155289da36a3c7f"
"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
"github.com/mitchellh/go-wordwrap ad45545899c7b13c020ea92b2072220eefad42b8"
"github.com/modern-go/concurrent bacd9c7ef1dd9b15be4a9909b8ac7a4e313eec94"
"github.com/modern-go/reflect2 94122c33edd36123c84d5368cfb2b69df93a0ec8"
"github.com/opencontainers/go-digest a6d0ee40d4207ea02364bd3b9e8e77b9159ba1eb"
"github.com/peterbourgon/diskv 5f041e8faa004a95c88a202771f4cc3e991971e6"
"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
"github.com/prometheus/client_golang c5b7fccd204277076155f10851dad72b76a49317"
"github.com/prometheus/client_model fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
"github.com/prometheus/common 13ba4ddd0caa9c28ca7b7bffe1dfa9ed8d5ef207"
"github.com/prometheus/procfs 65c1f6f8f0fc1e2185eb9863a3bc751496404259"
"github.com/PuerkitoBio/purell 8a290539e2e8629dbc4e6bad948158f790ec31f4"
"github.com/PuerkitoBio/urlesc 5bd2802263f21d8788851d5305584c82a5c75d7e"
"github.com/russross/blackfriday 300106c228d52c8941d4b3de6054a6062a86dda3"
"github.com/shurcooL/sanitized_anchor_name 10ef21a441db47d8b13ebcc5fd2310f636973c77"
"github.com/sirupsen/logrus 89742aefa4b206dcf400792f3bd35b542998eb3b"
"github.com/spf13/cobra fe5e611709b0c57fa4a89136deaa8e1d4004d053"
"github.com/spf13/pflag 298182f68c66c05229eb03ac171abe6e309ee79a"
"github.com/technosophos/moniker a5dbd03a2245d554160e3ae6bfdcf969fe58b431"
"golang.org/x/crypto de0752318171da717af4ce24d0a2e8626afaeb11 github.com/golang/crypto"
"golang.org/x/net 0ed95abb35c445290478a5348a7b38bb154135fd github.com/golang/net"
"golang.org/x/oauth2 a6bd8cefa1811bd24b86f8902872e4e8225f74c4 github.com/golang/oauth2"
"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
"golang.org/x/sys b90733256f2e882e81d52f9126de08df5615afd9 github.com/golang/sys"
"golang.org/x/text b19bf474d317b857955b12035d2c5acb57ce8b01 github.com/golang/text"
"golang.org/x/time f51c12702a4d776e4c1fa9b0fabab841babae631 github.com/golang/time"
"google.golang.org/appengine 12d5545dc1cfa6047a286d5e853841b6471f4c19 github.com/golang/appengine"
"google.golang.org/genproto 09f6ed296fc66555a25fe4ce95173148778dfa85 github.com/google/go-genproto"
"google.golang.org/grpc a02b0774206b209466313a0b525d2c738fe407eb github.com/grpc/grpc-go"
"gopkg.in/inf.v0 3887ee99ecf07df5b447e9b00d9c0b2adaa9f3e4 github.com/go-inf/inf"
"gopkg.in/square/go-jose.v2 89060dee6a84df9a4dae49f676f0c755037834f1 github.com/square/go-jose"
"gopkg.in/yaml.v2 670d4cfef0544295bc27a114dbac37980d83185a github.com/go-yaml/yaml"
"k8s.io/api 05914d821849570fba9eacfb29466f2d8d3cd229 github.com/kubernetes/api"
"k8s.io/apiextensions-apiserver 0fe22c71c47604641d9aa352c785b7912c200562 github.com/kubernetes/apiextensions-apiserver"
"k8s.io/apimachinery 2b1284ed4c93a43499e781493253e2ac5959c4fd github.com/kubernetes/apimachinery"
"k8s.io/apiserver 3ccfe8365421eb08e334b195786a2973460741d8 github.com/kubernetes/apiserver"
"k8s.io/client-go 8d9ed539ba3134352c586810e749e58df4e94e4f github.com/kubernetes/client-go"
"k8s.io/cli-runtime 835b10687cb6556f6b113099ef925146a56d5981 github.com/kubernetes/cli-runtime"
"k8s.io/klog 8139d8cb77af419532b33dfa7dd09fbc5f1d344f github.com/kubernetes/klog"
"k8s.io/kube-openapi c59034cc13d587f5ef4e85ca0ade0c1866ae8e1d github.com/kubernetes/kube-openapi"
"k8s.io/kubernetes c6d339953bd4fd8c021a6b5fb46d7952b30be9f9 github.com/kubernetes/kubernetes"
"k8s.io/utils 66066c83e385e385ccc3c964b44fd7dcd413d0ed github.com/kubernetes/utils"
"sigs.k8s.io/yaml fd68e9863619f6ec2fdd8625fe1f02e7c877e480 github.com/kubernetes-sigs/yaml"
"vbom.ml/util db5cfe13f5cc80a4990d98e2e1b0707a4d1a5394 github.com/fvbommel/util"
)

inherit golang-build golang-vcs-snapshot bash-completion-r1

GIT_COMMIT="618447cbf203d147601b4b9bd7f8c37a5d39fbb4"

ARCHIVE_URI="https://github.com/kubernetes/helm/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="amd64"

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
		-e "s#git describe --tags --abbrev=0 --exact-match 2>/dev/null#echo v${PV}#"\
		-e 's/test -n "`git status --porcelain`" && echo "dirty" ||//' src/${EGO_PN}/versioning.mk || die

	rm -rf src/${EGO_PN}/vendor/*/*/vendor src/${EGO_PN}/vendor/*/*/*/vendor  || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -o bin/protoc-gen-go ./vendor/github.com/golang/protobuf/protoc-gen-go || die
	GOBINDIR="$(pwd)/bin" GOPATH="${S}"\
	go install -v -ldflags "-X k8s.io/helm/pkg/version.Version=v${PV} -X k8s.io/helm/pkg/version.BuildMetadata= -X k8s.io/helm/pkg/version.GitCommit=${GIT_COMMIT} -X k8s.io/helm/pkg/version.GitTreeState=clean" k8s.io/helm/cmd/... || die
	popd || die
	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
}

src_install() {
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}

	dobin bin/${PN} bin/tiller
	dodoc src/${EGO_PN}/README.md
}
