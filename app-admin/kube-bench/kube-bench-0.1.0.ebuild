# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/aquasecurity/kube-bench"

EGO_VENDOR=(
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/fatih/color v1.5.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/golang/glog 23def4e6c14b"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/jinzhu/gorm 5174cc5c242a"
	"github.com/jinzhu/inflection 1c35d901db3d"
	"github.com/lib/pq 83612a56d3dd"
	"github.com/magiconair/properties v1.8.0"
	"github.com/mattn/go-colorable 5411d3eea597"
	"github.com/mattn/go-isatty 57fdcb988a5c"
	"github.com/mitchellh/mapstructure v1.1.2"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/spf13/afero v1.1.2"
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/cobra v0.0.1"
	"github.com/spf13/jwalterweatherman v1.0.0"
	"github.com/spf13/pflag v1.0.3"
	"github.com/spf13/viper v1.4.0"
	"github.com/stretchr/objx v0.1.1"
	"github.com/stretchr/testify v1.3.0"
	"golang.org/x/sys d0b11bdaac8a github.com/golang/sys"
	"golang.org/x/text 17ff2d5776d2 github.com/golang/text"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
	"k8s.io/client-go v10.0.0 github.com/kubernetes/client-go"
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
