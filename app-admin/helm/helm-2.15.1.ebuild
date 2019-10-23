# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="k8s.io/helm"

MY_PV=${PV/_rc/-rc.}

EGO_VENDOR=(
"cloud.google.com/go 0ebda48a7f143b1cce9eb37a8c1106ac762a3430 github.com/GoogleCloudPlatform/gcloud-golang"
"github.com/asaskevich/govalidator 7664702784775e51966f0885f5cd27435916517b"
"github.com/Azure/go-ansiterm d6e3b3328b783f23731bc4d058875b0371ff8109"
"github.com/Azure/go-autorest 1ffcc8896ef6dfe022d90a4317d866f925cf0f9e"
"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
"github.com/BurntSushi/toml 3012a1dbe2e4bd1391d42b32f0577cb7bbc7f005"
"github.com/chai2010/gettext-go c6fed771bfd517099caf0f7a961671fa8ed08723"
"github.com/cpuguy83/go-md2man 71acacd42f85e5e82f70a55327789582a5200a90"
"github.com/cyphar/filepath-securejoin a261ee33d7a517f054effbf451841abaafe3e0fd"
"github.com/davecgh/go-spew 8991bc29aa16c548c550c7ff78260e27b9ab7c73"
"github.com/dgrijalva/jwt-go 01aeca54ebda6e0fbfafd0a524d234159c05ec20"
"github.com/docker/distribution edc3ab29cdff8694dd6feb85cfeb4b5f1b38ed9c"
"github.com/docker/docker be7ac8be2ae072032a4005e8f232be3fc57e4127"
"github.com/docker/go-units 9e638d38cf6977a37a8ea0078f3ee75a7cdb2dd1"
"github.com/docker/spdystream 449fdfce4d962303d702fec724ef0ad181c92528"
"github.com/emicklei/go-restful ff4f55a206334ef123e4f79bbf348980da81ca46"
"github.com/evanphx/json-patch 5858425f75500d40c52783dce87d085a483ce135"
"github.com/exponent-io/jsonpath d6023ce2651d8eafb5c75bb0c7167536102ec9f5"
"github.com/fatih/camelcase f6a740d52f961c60348ebb109adde9f4635d7540"
"github.com/ghodss/yaml c7ce16629ff4cd059ed96ed06419dd3856fd3577"
"github.com/gofrs/flock 392e7fae8f1b0bdbd67dad7237d23f618feb6dbb"
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
"github.com/google/go-cmp 6f77996f0c42f7b84e5a2b252227263f93432e9b"
"github.com/google/gofuzz 24818f796faf91cd76ec7bddd72458fbced7a6c1"
"github.com/google/uuid 0cd6bf5da1e1c83f8b45653022c74f71af0538a4"
"github.com/googleapis/gnostic 0c5108395e2debce0d731cf0287ddf7242066aba"
"github.com/gophercloud/gophercloud c818fa66e4c88b30db28038fe3f18f2f4a0db9a8"
"github.com/gosuri/uitable 36ee7e946282a3fb1cfecd476ddc9b35d8847e42"
"github.com/gregjones/httpcache 787624de3eb7bd915c329cba748687a3b22666a6"
"github.com/grpc-ecosystem/go-grpc-prometheus 0c1b191dbfe51efdabe3c14b9f6f3b96429e0722"
"github.com/hashicorp/golang-lru 20f1fb78b0740ba8c3cb143a61e86ba5c8669768"
"github.com/huandu/xstrings f02667b379e2fb5916c3cda2cf31e0eb885d79f8"
"github.com/imdario/mergo 9316a62528ac99aaecb4e47eadd6dc8aa6533d58"
"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
"github.com/jmoiron/sqlx d161d7a76b5661016ad0b085869f77fd410f3e6a"
"github.com/json-iterator/go ab8a2e0c74be9d3be70b3184d9acc634935ded82"
"github.com/liggitt/tabwriter 89fcab3d43de07060e4fd4c1547430ed57e87f24"
"github.com/konsorten/go-windows-terminal-sequences 5c8c8bd35d3832f5d134ae1e1e375b69a4d25242"
"github.com/lib/pq 88edab0803230a3898347e77b474f8c1820a1f20"
"github.com/mailru/easyjson 60711f1a8329503b04e1c88535f419d0bb440bff"
"github.com/MakeNowJust/heredoc bb23615498cded5e105af4ce27de75b089cbe851"
"github.com/Masterminds/goutils 41ac8693c5c10a92ea1ff5ac3a7f95646f6123b0"
"github.com/Masterminds/semver 805c489aa98f412e79eb308a37996bf9d8b1c91e"
"github.com/Masterminds/sprig 2691a9cba2adee8d9a60100a1bc49e770f97b7db"
"github.com/Masterminds/vcs f94282d8632a0620f79f0c6ff0e82604e8c5c85b"
"github.com/mattn/go-runewidth d6bea18f789704b5f83375793155289da36a3c7f"
"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
"github.com/mitchellh/go-wordwrap ad45545899c7b13c020ea92b2072220eefad42b8"
"github.com/modern-go/concurrent bacd9c7ef1dd9b15be4a9909b8ac7a4e313eec94"
"github.com/modern-go/reflect2 94122c33edd36123c84d5368cfb2b69df93a0ec8"
"github.com/opencontainers/go-digest a6d0ee40d4207ea02364bd3b9e8e77b9159ba1eb"
"github.com/peterbourgon/diskv 5f041e8faa004a95c88a202771f4cc3e991971e6"
"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
"github.com/prometheus/client_golang 505eaef017263e299324067d40ca2c48f6a2cf50"
"github.com/prometheus/client_model fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
"github.com/prometheus/common 4724e9255275ce38f7179b2478abeae4e28c904f"
"github.com/prometheus/procfs 1dc9a6cbc91aacc3e8b2d63db4d2e957a5394ac4"
"github.com/PuerkitoBio/purell 0bcb03f4b4d0a9428594752bd2a3b9aa0a9d4bd4"
"github.com/PuerkitoBio/urlesc de5bf2ad457846296e2031421a34e2568e304e35"
"github.com/rubenv/sql-migrate 1007f53448d75fe14190968f5de4d95ed63ebb83"
"github.com/russross/blackfriday 300106c228d52c8941d4b3de6054a6062a86dda3"
"github.com/shurcooL/sanitized_anchor_name 10ef21a441db47d8b13ebcc5fd2310f636973c77"
"github.com/sirupsen/logrus bcd833dfe83d3cebad139e4a29ed79cb2318bf95"
"github.com/spf13/cobra f2b07da1e2c38d5f12845a4f607e2e1018cbb1f5"
"github.com/spf13/pflag e8f29969b682c41a730f8f08b76033b120498464"
"github.com/technosophos/moniker a5dbd03a2245d554160e3ae6bfdcf969fe58b431"
"golang.org/x/crypto e84da0312774c21d64ee2317962ef669b27ffb41 github.com/golang/crypto"
"golang.org/x/net 65e2d4e15006aab9813ff8769e768bbf4bb667a0 github.com/golang/net"
"golang.org/x/oauth2 9f3314589c9a9136388751d9adae6b0ed400978a github.com/golang/oauth2"
"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
"golang.org/x/sys b90733256f2e882e81d52f9126de08df5615afd9 github.com/golang/sys"
"golang.org/x/text e6919f6577db79269a6443b9dc46d18f2238fb5d github.com/golang/text"
"golang.org/x/time f51c12702a4d776e4c1fa9b0fabab841babae631 github.com/golang/time"
"google.golang.org/appengine 54a98f90d1c46b7731eb8fb305d2a321c30ef610 github.com/golang/appengine"
"google.golang.org/genproto 09f6ed296fc66555a25fe4ce95173148778dfa85 github.com/google/go-genproto"
"google.golang.org/grpc a02b0774206b209466313a0b525d2c738fe407eb github.com/grpc/grpc-go"
"gopkg.in/gorp.v1 6a667da9c028871f98598d85413e3fc4c6daa52e github.com/go-gorp/gorp"
"gopkg.in/inf.v0 3887ee99ecf07df5b447e9b00d9c0b2adaa9f3e4 github.com/go-inf/inf"
"gopkg.in/square/go-jose.v2 89060dee6a84df9a4dae49f676f0c755037834f1 github.com/square/go-jose"
"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml"
"k8s.io/api 7cf5895f2711098d7d9527db0a4a49fb0dff7de2 github.com/kubernetes/api"
"k8s.io/apiextensions-apiserver 14e95df34f1f469647f494f5185a036e26fddcab github.com/kubernetes/apiextensions-apiserver"
"k8s.io/apimachinery 1799e75a07195de9460b8ef7300883499f12127b github.com/kubernetes/apimachinery"
"k8s.io/apiserver 47dc9a115b1874c96c20cea91d02b36e4faa1bb1 github.com/kubernetes/apiserver"
"k8s.io/client-go 78d2af792babf2dd937ba2e2a8d99c753a5eda89 github.com/kubernetes/client-go"
"k8s.io/cli-runtime 2090e6d8f84c1db3e23968b0ee97fb677b363fcf github.com/kubernetes/cli-runtime"
"k8s.io/component-base 185d68e6e6ea654214f444cab8f645ec3af3092e github.com/kubernetes/component-base"
"k8s.io/klog 89e63fd5117f8c20208186ef85f096703a280c20 github.com/kubernetes/klog"
"k8s.io/kube-openapi b3a7cee44a305be0a69e1b9ac03018307287e1b0 github.com/kubernetes/kube-openapi"
"k8s.io/kubernetes e8462b5b5dc2584fdcd18e6bcfe9f1e4d970a529 github.com/kubernetes/kubernetes"
"k8s.io/utils c2654d5206da6b7b6ace12841e8f359bb89b443c github.com/kubernetes/utils"
"sigs.k8s.io/kustomize a6f65144121d1955266b0cd836ce954c04122dc8 github.com/kubernetes-sigs/kustomize"
"sigs.k8s.io/yaml fd68e9863619f6ec2fdd8625fe1f02e7c877e480 github.com/kubernetes-sigs/yaml"
"vbom.ml/util db5cfe13f5cc80a4990d98e2e1b0707a4d1a5394 github.com/fvbommel/util"
)

inherit golang-build golang-vcs-snapshot bash-completion-r1

GIT_COMMIT="cf1de4f8ba70eded310918a8af3a96bfe8e7683b"

ARCHIVE_URI="https://github.com/kubernetes/helm/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://github.com/kubernetes/helm https://helm.sh"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.12"

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
