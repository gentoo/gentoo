# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/aquasecurity/kube-bench"

EGO_VENDOR=(
	"github.com/PuerkitoBio/purell v1.1.1"
	"github.com/PuerkitoBio/urlesc de5bf2ad4578"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/emicklei/go-restful v2.9.6"
	"github.com/evanphx/json-patch v4.5.0"
	"github.com/fatih/color v1.5.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/go-openapi/jsonpointer v0.19.2"
	"github.com/go-openapi/jsonreference v0.19.2"
	"github.com/go-openapi/spec v0.19.2"
	"github.com/go-openapi/swag v0.19.2"
	"github.com/gogo/protobuf v1.2.1"
	"github.com/golang/glog 23def4e6c14b"
	"github.com/golang/protobuf v1.3.1"
	"github.com/google/gofuzz v1.0.0"
	"github.com/googleapis/gnostic v0.3.0"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/imdario/mergo v0.3.5"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/jinzhu/gorm 5174cc5c242a"
	"github.com/jinzhu/inflection 1c35d901db3d"
	"github.com/json-iterator/go v1.1.6"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.1"
	"github.com/lib/pq 83612a56d3dd"
	"github.com/magiconair/properties v1.8.0"
	"github.com/mailru/easyjson da37f6c1e481"
	"github.com/mattn/go-colorable 5411d3eea597"
	"github.com/mattn/go-isatty 57fdcb988a5c"
	"github.com/mitchellh/mapstructure v1.1.2"
	"github.com/modern-go/concurrent bacd9c7ef1dd"
	"github.com/modern-go/reflect2 v1.0.1"
	"github.com/onsi/ginkgo v1.10.1"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/pkg/errors v0.8.1"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/sirupsen/logrus v1.4.1"
	"github.com/spf13/afero v1.2.2"
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/jwalterweatherman v1.0.0"
	"github.com/spf13/pflag v1.0.3"
	"github.com/spf13/viper v1.4.0"
	"github.com/stretchr/objx v0.2.0"
	"github.com/stretchr/testify v1.3.0"
	"golang.org/x/crypto 5c40567a22f8 github.com/golang/crypto"
	"golang.org/x/net 3b0461eec859 github.com/golang/net"
	"golang.org/x/oauth2 9f3314589c9a github.com/golang/oauth2"
	"golang.org/x/sys d432491b9138 github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/time 9d24e82272b4 github.com/golang/time"
	"google.golang.org/appengine v1.5.0 github.com/golang/appengine"
	"gopkg.in/inf.v0 v0.9.1 github.com/go-inf/inf"
	"gopkg.in/yaml.v2 v2.2.4 github.com/go-yaml/yaml"
	"k8s.io/api 6e4e0e4f393b github.com/kubernetes/api"
	"k8s.io/apimachinery 6a84e37a896d github.com/kubernetes/apimachinery"
	"k8s.io/client-go v11.0.0 github.com/kubernetes/client-go"
	"k8s.io/klog v0.3.3 github.com/kubernetes/klog"
	"k8s.io/kube-openapi db7b694dc208 github.com/kubernetes/kube-openapi"
	"k8s.io/utils 6ca3b61696b6 github.com/kubernetes/utils"
	"sigs.k8s.io/kind v0.5.1 github.com/kubernetes-sigs/kind"
	"sigs.k8s.io/kustomize/v3 4b67a6de1296 github.com/kubernetes-sigs/kustomize"
	"sigs.k8s.io/yaml v1.1.0 github.com/kubernetes-sigs/yaml"
)

inherit golang-build golang-vcs-snapshot bash-completion-r1

ARCHIVE_URI="https://github.com/aquasecurity/kube-bench/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Kubernetes Bench for Security runs the CIS Kubernetes Benchmark"
HOMEPAGE="https://github.com/aquasecurity/kube-bench"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GO111MODULE=on GOPATH="${S}" go build -mod vendor -v -ldflags "-X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=${PV}" -o ${PN} . || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/${PN}
	insinto /etc/kube-bench
	doins -r src/${EGO_PN}/cfg
}
