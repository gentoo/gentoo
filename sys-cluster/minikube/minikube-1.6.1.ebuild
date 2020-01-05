# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit python-any-r1 go-module

EGIT_COMMIT="42a9df4854dcea40ec187b6b8f9a910c6038f81a"

EGO_VENDOR=(
	"cloud.google.com/go v0.49.0 github.com/googleapis/google-cloud-go"
	"github.com/aws/aws-sdk-go v1.16.26"
	"github.com/bgentry/go-netrc 9fd32a8b3d3d3f9d43c341bfe098430e07609480"
	"github.com/blang/semver v3.5.0"
	"github.com/cenkalti/backoff v2.2.1"
	"github.com/cheggaaa/pb v3.0.1"
	"github.com/cloudfoundry-attic/jibber_jabber bcc4c8345a21301bf47c032ff42dd1aae2fe3027"
	"github.com/cpuguy83/go-md2man v1.0.10"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/docker/distribution edc3ab29cdff8694dd6feb85cfeb4b5f1b38ed9c"
	"github.com/docker/docker v1.13.1"
	"github.com/docker/go-connections v0.3.0"
	"github.com/docker/go-units v0.3.3"
	"github.com/docker/machine a555e4f7a8f518a8b1b174824c377e46cbfc4fe2"
	"github.com/docker/spdystream 449fdfce4d962303d702fec724ef0ad181c92528"
	"github.com/fatih/color v1.7.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/gogo/protobuf v1.1.1"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/golang/groupcache 02826c3e79038b59d737d3b1c0a1d937f71a4433"
	"github.com/golang/protobuf v1.3.2"
	"github.com/googleapis/gax-go v2.0.5"
	"github.com/googleapis/gnostic 0c5108395e2debce0d731cf0287ddf7242066aba"
	"github.com/google/go-cmp v0.3.0"
	"github.com/google/go-containerregistry 697ee0b3d46eff19ed2b30f86230377061203f79"
	"github.com/google/gofuzz v1.0.0"
	"github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55"
	"github.com/hashicorp/go-cleanhttp v0.5.0"
	"github.com/hashicorp/go-getter v1.4.0"
	"github.com/hashicorp/golang-lru v0.5.1"
	"github.com/hashicorp/go-multierror 8c5f0ad9360406a3807ce7de6bc73269a91a6e51"
	"github.com/hashicorp/go-safetemp v1.0.0"
	"github.com/hashicorp/go-version v1.1.0"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/imdario/mergo v0.3.5"
	"github.com/intel-go/cpuid 1a4a6f06a1c643c8fbd339bd61d980960627d09e"
	"github.com/jimmidyson/go-download 7f9a90c8c95bee1bb7de9e72c682c67c8bf5546d"
	"github.com/jmespath/go-jmespath c2b33e8439af944379acbdd9c3a5fe0bc44bd8a5"
	"github.com/json-iterator/go v1.1.6"
	"github.com/juju/clock 9c5c9712527c7986f012361e7d13756b4d99543d"
	"github.com/juju/errors 0232dcc7464d0c0037b619d6e10190301d01362f"
	"github.com/juju/mutex d21b13acf4bfd8a8b0482a3a78e44d98880b40d3"
	"github.com/kballard/go-shellquote 95032a82bc518f77982ea72343cc1ade730072f0"
	"github.com/libvirt/libvirt-go v3.4.0"
	"github.com/machine-drivers/docker-machine-driver-vmware v0.1.1"
	"github.com/magiconair/properties v1.8.0"
	"github.com/MakeNowJust/heredoc bb23615498cded5e105af4ce27de75b089cbe851"
	"github.com/mattn/go-colorable v0.1.2"
	"github.com/mattn/go-isatty v0.0.8"
	"github.com/mattn/go-runewidth v0.0.4"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/mitchellh/go-ps 4fdf99ab29366514c69ccccddab5dc58b8d84062"
	"github.com/mitchellh/go-testing-interface v1.0.0"
	"github.com/mitchellh/go-wordwrap v1.0.0"
	"github.com/mitchellh/mapstructure v1.1.2"
	"github.com/modern-go/concurrent bacd9c7ef1dd9b15be4a9909b8ac7a4e313eec94"
	"github.com/modern-go/reflect2 v1.0.1"
	"github.com/olekukonko/tablewriter bdcc175572fd7abece6c831e643891b9331bc9e7"
	"github.com/opencontainers/go-digest a6d0ee40d4207ea02364bd3b9e8e77b9159ba1eb"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/pkg/browser 9302be274faad99162b9d48ec97b24306872ebb0"
	"github.com/pkg/errors v0.8.1"
	"github.com/pkg/profile 3a8809bd8a80f8ecfe4ee1b34b3f37194968617c"
	"github.com/russross/blackfriday v1.5.2"
	"github.com/samalba/dockerclient 91d7393ff85980ba3a8966405871a3d446ca28f2"
	"github.com/shirou/gopsutil v2.18.12"
	"github.com/spf13/afero v1.1.2"
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/cobra v0.0.5"
	"github.com/spf13/jwalterweatherman v1.0.0"
	"github.com/spf13/pflag v1.0.3"
	"github.com/spf13/viper v1.3.2"
	"github.com/ulikunitz/xz v0.5.5"
	"github.com/VividCortex/ewma v1.1.1"
	"golang.org/x/crypto 5c40567a22f818bd14a1ea7245dad9f8ef0691aa github.com/golang/crypto"
	"golang.org/x/net 3b0461eec859c4b73bb64fdc8285971fd33e3938 github.com/golang/net"
	"golang.org/x/oauth2 0f29369cfe4552d0e4bcddc57cc75f4d7e672a33 github.com/golang/oauth2"
	"golang.org/x/sync 112230192c580c3556b8cee6403af37a4fc5f28c github.com/golang/sync"
	"golang.org/x/sys 04f50cda93cbb67f2afa353c52f342100e80e625 github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/time 9d24e82272b4f38b78bc8cff74fa936d31ccd8ef github.com/golang/time"
	"google.golang.org/api v0.9.0 github.com/googleapis/google-api-go-client"
	"google.golang.org/genproto 24fa4b261c55da65468f2abfdae2b024eef27dfb github.com/googleapis/go-genproto"
	"google.golang.org/grpc v1.21.1 github.com/grpc/grpc-go"
	"go.opencensus.io v0.22.2 github.com/census-instrumentation/opencensus-go"
	"gopkg.in/cheggaaa/pb.v1 v1.0.27 github.com/cheggaaa/pb"
	"gopkg.in/inf.v0 v0.9.1 github.com/go-inf/inf"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
	"k8s.io/klog v0.3.1 github.com/kubernetes/klog"
	"k8s.io/kubernetes 8c3b7d7679ccf368cc4cedb352fac4cd1b82124e github.com/kubernetes/kubernetes"
	"k8s.io/utils c2654d5206da6b7b6ace12841e8f359bb89b443c github.com/kubernetes/utils"
	"sigs.k8s.io/yaml v1.1.0 github.com/kubernetes-sigs/yaml"
)

KEYWORDS="~amd64"

DESCRIPTION="Single Node Kubernetes Cluster"
HOMEPAGE="https://github.com/kubernetes/minikube https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-4.0 CC-BY-SA-4.0 CC0-1.0 GPL-2 ISC LGPL-3 MIT MPL-2.0 WTFPL-2 ZLIB || ( LGPL-3+ GPL-2 ) || ( Apache-2.0 LGPL-3+ ) || ( Apache-2.0 CC-BY-4.0 )"
SLOT="0"
IUSE="hardened libvirt"

RDEPEND=">=sys-cluster/kubectl-1.14.0
	libvirt? ( app-emulation/libvirt:=[qemu] )"
DEPEND="${RDEPEND}
	dev-go/go-bindata
	${PYTHON_DEPS}"

RESTRICT="test"

src_prepare() {
	default
	mv vendor/k8s.io/kubernetes/staging/src/k8s.io/* vendor/k8s.io || die
	rm -rf vendor/k8s.io/kubernetes/staging || die
	sed -i -e "s/get_commit(), get_tree_state(), get_version()/get_commit(), 'gitTreeState=clean', get_version()/"  hack/get_k8s_version.py || die
	sed -i -e "s|^COMMIT ?=.*|COMMIT = ${EGIT_COMMIT}|" -e "s|^COMMIT_NO :=.*|COMMIT_NO = ${EGIT_COMMIT}|" -i Makefile || die
}

src_compile() {
	export -n GOCACHE GOPATH XDG_CACHE_HOME
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')"
	LDFLAGS="" emake  $(usex libvirt "out/docker-machine-driver-kvm2" "") out/minikube-linux-amd64
}

src_install() {
	newbin out/minikube-linux-amd64 minikube
	use libvirt && dobin out/docker-machine-driver-kvm2
	dodoc -r docs CHANGELOG.md README.md
}

pkg_postinst() {
	elog "You may want to install the following optional dependency:"
	elog "  app-emulation/virtualbox or app-emulation/virtualbox-bin"
}
