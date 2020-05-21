# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="k8s.io/helm"

MY_PV=${PV/_rc/-rc.}

EGO_VENDOR=(
"cloud.google.com/go 8c41231e01b2085512d98153bcffb847ff9b4b9f github.com/GoogleCloudPlatform/gcloud-golang"
"github.com/asaskevich/govalidator 7664702784775e51966f0885f5cd27435916517b"
"github.com/Azure/go-ansiterm d6e3b3328b783f23731bc4d058875b0371ff8109"
"github.com/Azure/go-autorest 69b4126ece6b5257e2f9b0017007d2334153655f"
"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
"github.com/BurntSushi/toml 3012a1dbe2e4bd1391d42b32f0577cb7bbc7f005"
"github.com/chai2010/gettext-go c6fed771bfd517099caf0f7a961671fa8ed08723"
"github.com/cpuguy83/go-md2man 7762f7e404f8416dfa1d9bb6a8c192aa9acb4d19"
"github.com/cyphar/filepath-securejoin a261ee33d7a517f054effbf451841abaafe3e0fd"
"github.com/davecgh/go-spew 8991bc29aa16c548c550c7ff78260e27b9ab7c73"
"github.com/dgrijalva/jwt-go 06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
"github.com/docker/distribution 2461543d988979529609e8cb6fca9ca190dc48da"
"github.com/docker/docker be7ac8be2ae072032a4005e8f232be3fc57e4127"
"github.com/docker/go-units 9e638d38cf6977a37a8ea0078f3ee75a7cdb2dd1"
"github.com/docker/spdystream 449fdfce4d962303d702fec724ef0ad181c92528"
"github.com/emicklei/go-restful ff4f55a206334ef123e4f79bbf348980da81ca46"
"github.com/evanphx/json-patch 5858425f75500d40c52783dce87d085a483ce135"
"github.com/exponent-io/jsonpath d6023ce2651d8eafb5c75bb0c7167536102ec9f5"
"github.com/fatih/color 3f9d52f7176a6927daacff70a3e8d1dc2025c53e"
"github.com/ghodss/yaml c7ce16629ff4cd059ed96ed06419dd3856fd3577"
"github.com/gofrs/flock 392e7fae8f1b0bdbd67dad7237d23f618feb6dbb"
"github.com/go-openapi/jsonpointer 46af16f9f7b149af66e5d1bd010e3574dc06de98"
"github.com/go-openapi/jsonreference 13c6e3589ad90f49bd3e3bbe2c2cb3d7a4142272"
"github.com/go-openapi/spec 6aced65f8501fe1217321abf0749d354824ba2ff"
"github.com/go-openapi/swag 1d0bd113de87027671077d3c71eb3ac5d7dbba72"
"github.com/gobwas/glob 5ccd90ef52e1e632236f7326478d4faa74f99438"
"github.com/gogo/protobuf 65acae22fc9d1fe290b33faa2bd64cdc20a463a0"
"github.com/golang/glog 44145f04b68cf362d9c4df2182967c2275eaefed"
"github.com/golang/groupcache 02826c3e79038b59d737d3b1c0a1d937f71a4433"
"github.com/golang/protobuf 6c65a5562fc06764971b7c5d05c76c75e84bdbf7"
"github.com/google/btree 4030bb1f1f0c35b30ca7009e9ebd06849dd45306"
"github.com/google/go-cmp 6f77996f0c42f7b84e5a2b252227263f93432e9b"
"github.com/google/gofuzz f140a6486e521aad38f5917de355cbf147cc0496"
"github.com/google/uuid 0cd6bf5da1e1c83f8b45653022c74f71af0538a4"
"github.com/googleapis/gnostic 0c5108395e2debce0d731cf0287ddf7242066aba"
"github.com/gophercloud/gophercloud c2d73b246b48e239d3f03c455905e06fe26e33c3"
"github.com/gosuri/uitable 2cf933346b8370a3a3d8867ef5cf54b2129d8ecf"
"github.com/gregjones/httpcache 787624de3eb7bd915c329cba748687a3b22666a6"
"github.com/grpc-ecosystem/go-grpc-prometheus 6af20e3a5340d5e6bde20c8a7a78699efe19ac0a"
"github.com/hashicorp/golang-lru 7087cb70de9f7a8bc0a10c375cb0d2280a8edf9c"
"github.com/huandu/xstrings f02667b379e2fb5916c3cda2cf31e0eb885d79f8"
"github.com/imdario/mergo 9316a62528ac99aaecb4e47eadd6dc8aa6533d58"
"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
"github.com/jmoiron/sqlx d161d7a76b5661016ad0b085869f77fd410f3e6a"
"github.com/json-iterator/go 27518f6661eba504be5a7a9a9f6d9460d892ade3"
"github.com/konsorten/go-windows-terminal-sequences 5c8c8bd35d3832f5d134ae1e1e375b69a4d25242"
"github.com/lib/pq f91d3411e481ed313eeab65ebfe9076466c39d01"
"github.com/liggitt/tabwriter 89fcab3d43de07060e4fd4c1547430ed57e87f24"
"github.com/mailru/easyjson d5b7844b561a7bc640052f1b935f7b800330d7e0"
"github.com/MakeNowJust/heredoc bb23615498cded5e105af4ce27de75b089cbe851"
"github.com/Masterminds/goutils 41ac8693c5c10a92ea1ff5ac3a7f95646f6123b0"
"github.com/Masterminds/semver 805c489aa98f412e79eb308a37996bf9d8b1c91e"
"github.com/Masterminds/sprig e4c0945838d570720d876a6ad9b4568ed32317b4"
"github.com/Masterminds/vcs f94282d8632a0620f79f0c6ff0e82604e8c5c85b"
"github.com/mattn/go-colorable 98ec13f34aabf44cc914c65a1cfb7b9bc815aef1"
"github.com/mattn/go-isatty 0e9ddb7c0c0aef74fa25eaba4141e6b5ab7aca2a"
"github.com/mattn/go-runewidth 9d4e0701ab53d89eeb2f46b282d1cd71f458f0bf"
"github.com/matttproud/golang_protobuf_extensions c12348ce28de40eed0136aa2b644d0ee0650e56c"
"github.com/mitchellh/copystructure 9a1b6f44e8da0e0e374624fb0a825a231b00c537"
"github.com/mitchellh/go-wordwrap 9e67c67572bc5dd02aef930e2b0ae3c02a4b5a5c"
"github.com/mitchellh/reflectwalk 3e2c75dfad4fbf904b58782a80fd595c760ad185"
"github.com/modern-go/concurrent bacd9c7ef1dd9b15be4a9909b8ac7a4e313eec94"
"github.com/modern-go/reflect2 94122c33edd36123c84d5368cfb2b69df93a0ec8"
"github.com/opencontainers/go-digest 279bed98673dd5bef374d3b6e4b09e2af76183bf"
"github.com/peterbourgon/diskv 5f041e8faa004a95c88a202771f4cc3e991971e6"
"github.com/pkg/errors 27936f6d90f9c8e1145f11ed52ffffbfdb9e0af7"
"github.com/prometheus/client_golang 505eaef017263e299324067d40ca2c48f6a2cf50"
"github.com/prometheus/client_model 5c3871d89910bfb32f5fcab2aa4b9ec68e65a99f"
"github.com/prometheus/common 4724e9255275ce38f7179b2478abeae4e28c904f"
"github.com/prometheus/procfs 1dc9a6cbc91aacc3e8b2d63db4d2e957a5394ac4"
"github.com/PuerkitoBio/purell 8a290539e2e8629dbc4e6bad948158f790ec31f4"
"github.com/PuerkitoBio/urlesc 5bd2802263f21d8788851d5305584c82a5c75d7e"
"github.com/rubenv/sql-migrate 9355dd04f4b3dc9ed604623307307a3491a627bc"
"github.com/russross/blackfriday 05f3235734ad95d0016f6a23902f06461fcf567a"
"github.com/sirupsen/logrus 839c75faf7f98a33d445d181f3018b5c3409a45e"
"github.com/spf13/cobra f2b07da1e2c38d5f12845a4f607e2e1018cbb1f5"
"github.com/spf13/pflag 2e9d26c8c37aae03e3f9d4e90b7116f5accb7cab"
"github.com/technosophos/moniker a5dbd03a2245d554160e3ae6bfdcf969fe58b431"
"golang.org/x/crypto e84da0312774c21d64ee2317962ef669b27ffb41 github.com/golang/crypto"
"golang.org/x/net cdfb69ac37fc6fa907650654115ebebb3aae2087 github.com/golang/net"
"golang.org/x/oauth2 9f3314589c9a9136388751d9adae6b0ed400978a github.com/golang/oauth2"
"golang.org/x/sync 42b317875d0fa942474b76e1b46a6060d720ae6e github.com/golang/sync"
"golang.org/x/sys b90733256f2e882e81d52f9126de08df5615afd9 github.com/golang/sys"
"golang.org/x/text e6919f6577db79269a6443b9dc46d18f2238fb5d github.com/golang/text"
"golang.org/x/time f51c12702a4d776e4c1fa9b0fabab841babae631 github.com/golang/time"
"google.golang.org/appengine 54a98f90d1c46b7731eb8fb305d2a321c30ef610 github.com/golang/appengine"
"google.golang.org/genproto 919d9bdd9fe6f1a5dd95ce5d5e4cdb8fd3c516d0 github.com/google/go-genproto"
"google.golang.org/grpc a02b0774206b209466313a0b525d2c738fe407eb github.com/grpc/grpc-go"
"gopkg.in/gorp.v1 6a667da9c028871f98598d85413e3fc4c6daa52e github.com/go-gorp/gorp"
"gopkg.in/inf.v0 3887ee99ecf07df5b447e9b00d9c0b2adaa9f3e4 github.com/go-inf/inf"
"gopkg.in/square/go-jose.v2 e94fb177d3668d35ab39c61cbb2f311550557e83 github.com/square/go-jose"
"gopkg.in/yaml.v2 f221b8435cfb71e54062f6c6e99e9ade30b124d5 github.com/go-yaml/yaml"
"k8s.io/api 35e52d86657aba06859dd22099bfa14faf1effb2 github.com/kubernetes/api"
"k8s.io/apiextensions-apiserver 5357c4baaf6562e4d37c9afc9fef99bd16d76a9f github.com/kubernetes/apiextensions-apiserver"
"k8s.io/apimachinery a2eda9f80ab8a454a81bdde16d62a1afe5f931c0 github.com/kubernetes/apimachinery"
"k8s.io/apiserver 5190913f932d82e562d4eb91d0f3d7a063bdbc07 github.com/kubernetes/apiserver"
"k8s.io/client-go bec269661e48cb1e5fbb0d037f356ffe9e9978a0 github.com/kubernetes/client-go"
"k8s.io/cli-runtime 74ad18325ed51ea6de9ee19bae59156bad18ecd2 github.com/kubernetes/cli-runtime"
"k8s.io/component-base 039242c015a9f5eeaccea3ea17c6973b9c27166a github.com/kubernetes/component-base"
"k8s.io/klog 3ca30a56d8a775276f9cdae009ba326fdc05af7f github.com/kubernetes/klog"
"k8s.io/kube-openapi 743ec37842bffe49dd4221d9026f30fb1d5adbc4 github.com/kubernetes/kube-openapi"
"k8s.io/kubectl 2ed914427d51f6fd865e0db43d72b2f22610cf32 github.com/kubernetes/kubectl"
"k8s.io/kubernetes c97fe5036ef3df2967d086711e6c0c405941e14b github.com/kubernetes/kubernetes"
"k8s.io/utils 581e00157fb1a0435d4fac54a52d1ca1e481d60e github.com/kubernetes/utils"
"sigs.k8s.io/kustomize a6f65144121d1955266b0cd836ce954c04122dc8 github.com/kubernetes-sigs/kustomize"
"sigs.k8s.io/yaml fd68e9863619f6ec2fdd8625fe1f02e7c877e480 github.com/kubernetes-sigs/yaml"
"vbom.ml/util efcd4e0f97874370259c7d93e12aad57911dea81 github.com/fvbommel/util"
)

inherit golang-build golang-vcs-snapshot bash-completion-r1

GIT_COMMIT="bbdfe5e7803a12bbdf97e94cd847859890cf4050"

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
