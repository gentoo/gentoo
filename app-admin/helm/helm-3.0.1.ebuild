# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module bash-completion-r1

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://github.com/helm/helm https://helm.sh"

EGO_VENDOR=(
	"github.com/Nvveen/Gotty a8b993ba6abdb0e0c12b0125c603323a71c7790c github.com/ijc25/Gotty"
	"cloud.google.com/go v0.38.0 github.com/GoogleCloudPlatform/gcloud-golang"
	"github.com/Azure/go-ansiterm d6e3b3328b78"
	"github.com/Azure/go-autorest v13.0.0"
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/MakeNowJust/heredoc e9091a26100e"
	"github.com/Masterminds/goutils v1.1.0"
	"github.com/Masterminds/semver/v3 v3.0.1 github.com/Masterminds/semver"
	"github.com/Masterminds/sprig/v3 v3.0.0 github.com/Masterminds/sprig"
	"github.com/Masterminds/vcs v1.13.0"
	"github.com/Microsoft/go-winio v0.4.12"
	"github.com/Microsoft/hcsshim v0.8.6"
	"github.com/PuerkitoBio/purell v1.1.1"
	"github.com/PuerkitoBio/urlesc de5bf2ad4578"
	"github.com/Shopify/logrus-bugsnag 577dee27f20d"
	"github.com/asaskevich/govalidator f61b66f89f4a"
	"github.com/beorn7/perks v1.0.1"
	"github.com/bshuster-repo/logrus-logstash-hook v0.4.1"
	"github.com/bugsnag/bugsnag-go v1.5.0"
	"github.com/bugsnag/panicwrap v1.2.0"
	"github.com/cespare/xxhash/v2 v2.1.0 github.com/cespare/xxhash"
	"github.com/containerd/containerd v1.3.0"
	"github.com/containerd/continuity 004b46473808"
	"github.com/cpuguy83/go-md2man v1.0.10"
	"github.com/cyphar/filepath-securejoin v0.2.2"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/deislabs/oras v0.7.0"
	"github.com/dgrijalva/jwt-go v3.2.0"
	"github.com/docker/cli d88565df0c2d"
	"github.com/docker/distribution v2.7.1"
	"github.com/docker/docker 2cb26cfe9cbf"
	"github.com/docker/docker-credential-helpers v0.6.1"
	"github.com/docker/go-connections v0.4.0"
	"github.com/docker/go-metrics b84716841b82"
	"github.com/docker/go-units v0.4.0"
	"github.com/docker/libtrust aabc10ec26b7"
	"github.com/docker/spdystream 6480d4af844c"
	"github.com/emicklei/go-restful v2.11.1"
	"github.com/evanphx/json-patch v4.5.0"
	"github.com/exponent-io/jsonpath d6023ce2651d"
	"github.com/garyburd/redigo v1.6.0"
	"github.com/ghodss/yaml v1.0.0"
	"github.com/go-openapi/jsonpointer v0.19.3"
	"github.com/go-openapi/jsonreference v0.19.3"
	"github.com/go-openapi/spec v0.19.4"
	"github.com/go-openapi/swag v0.19.5"
	"github.com/gobwas/glob v0.2.3"
	"github.com/gofrs/flock v0.7.1"
	"github.com/gofrs/uuid v3.2.0"
	"github.com/gogo/protobuf v1.3.1"
	"github.com/golang/protobuf v1.3.2"
	"github.com/google/btree v1.0.0"
	"github.com/google/go-cmp v0.3.1"
	"github.com/google/gofuzz v1.0.0"
	"github.com/google/uuid v1.1.1"
	"github.com/googleapis/gnostic v0.3.1"
	"github.com/gophercloud/gophercloud v0.1.0"
	"github.com/gorilla/handlers v1.4.0"
	"github.com/gorilla/mux v1.7.0"
	"github.com/gosuri/uitable v0.0.1"
	"github.com/gregjones/httpcache c63ab54fda8f"
	"github.com/hashicorp/golang-lru v0.5.3"
	"github.com/huandu/xstrings v1.2.0"
	"github.com/imdario/mergo v0.3.8"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/json-iterator/go v1.1.7"
	"github.com/kardianos/osext ae77be60afb1"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1"
	"github.com/mailru/easyjson v0.7.0"
	"github.com/mattn/go-runewidth v0.0.4"
	"github.com/mattn/go-shellwords v1.0.5"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	"github.com/miekg/dns 0d29b283ac0f"
	"github.com/mitchellh/copystructure v1.0.0"
	"github.com/mitchellh/go-wordwrap v1.0.0"
	"github.com/mitchellh/reflectwalk v1.0.0"
	"github.com/modern-go/concurrent bacd9c7ef1dd"
	"github.com/modern-go/reflect2 v1.0.1"
	"github.com/morikuni/aec 39771216ff4c"
	"github.com/opencontainers/go-digest v1.0.0-rc1"
	"github.com/opencontainers/image-spec v1.0.1"
	"github.com/opencontainers/runc v0.1.1"
	"github.com/peterbourgon/diskv v2.0.1"
	"github.com/pkg/errors v0.8.1"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/prometheus/client_golang v1.2.1"
	"github.com/prometheus/client_model 14fe0d1b01d4"
	"github.com/prometheus/common v0.7.0"
	"github.com/prometheus/procfs v0.0.5"
	"github.com/russross/blackfriday v1.5.2"
	"github.com/sirupsen/logrus v1.4.2"
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/cobra v0.0.5"
	"github.com/spf13/pflag v1.0.5"
	"github.com/stretchr/testify v1.4.0"
	"github.com/xeipuuv/gojsonpointer 4e3ac2762d5f"
	"github.com/xeipuuv/gojsonreference bd5ef7bd5415"
	"github.com/xeipuuv/gojsonschema v1.1.0"
	"github.com/xenolf/lego a9d8cec0e656"
	"github.com/yvasiyarov/go-metrics c25f46c4b940"
	"github.com/yvasiyarov/gorelic v0.0.6"
	"github.com/yvasiyarov/newrelic_platform_go b21fdbd4370f"
	"golang.org/x/crypto f83a4685e152 github.com/golang/crypto"
	"golang.org/x/net fe3aa8a45271 github.com/golang/net"
	"golang.org/x/oauth2 0f29369cfe45 github.com/golang/oauth2"
	"golang.org/x/sync 112230192c58 github.com/golang/sync"
	"golang.org/x/sys 195ce5e7f934 github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/time 555d28b269f0 github.com/golang/time"
	"google.golang.org/appengine v1.6.5 github.com/golang/appengine"
	"google.golang.org/genproto 919d9bdd9fe6 github.com/google/go-genproto"
	"google.golang.org/grpc v1.24.0 github.com/grpc/grpc-go"
	"gopkg.in/inf.v0 v0.9.1 github.com/go-inf/inf"
	"gopkg.in/square/go-jose.v1 v1.1.2 github.com/square/go-jose"
	"gopkg.in/yaml.v2 v2.2.4 github.com/go-yaml/yaml"
	"k8s.io/api 35e52d86657a github.com/kubernetes/api"
	"k8s.io/apiextensions-apiserver 5357c4baaf65 github.com/kubernetes/apiextensions-apiserver"
	"k8s.io/apimachinery a2eda9f80ab8 github.com/kubernetes/apimachinery"
	"k8s.io/cli-runtime 74ad18325ed5 github.com/kubernetes/cli-runtime"
	"k8s.io/client-go bec269661e48 github.com/kubernetes/client-go"
	"k8s.io/klog v1.0.0 github.com/kubernetes/klog"
	"k8s.io/kube-openapi 0270cf2f1c1d github.com/kubernetes/kube-openapi"
	"k8s.io/kubectl 2ed914427d51 github.com/kubernetes/kubectl"
	"k8s.io/utils 8d271d903fe4 github.com/kubernetes/utils"
	"rsc.io/letsencrypt v0.0.1 github.com/rsc/letsencrypt"
	"sigs.k8s.io/kustomize v2.0.3 github.com/kubernetes-sigs/kustomize"
	"sigs.k8s.io/yaml v1.1.0 github.com/kubernetes-sigs/yaml"
)

MY_PV=${PV/_rc/-rc.}
SRC_URI="https://github.com/helm/helm/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip test"

GIT_COMMIT=7c22ef9ce89e0ebeb7125ba2ebf7d421f3e82ffa

src_prepare() {
	default
	sed -i -e "s/git rev-parse HEAD/echo ${GIT_COMMIT}/"\
		-e "s/git rev-parse --short HEAD/echo ${GIT_COMMIT:0:7}/"\
		-e "s#git describe --tags --abbrev=0 --exact-match 2>/dev/null#echo v${PV}#"\
		-e 's/test -n "`git status --porcelain`" && echo "dirty" || //' \
		-e "/GOFLAGS    :=/d" \
		Makefile || die
}

src_compile() {
	emake LDFLAGS= build
	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
}

src_install() {
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}

	dobin bin/${PN}
	dodoc README.md
}
