# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/aquasecurity/kube-bench"

EGO_VENDOR=(
	"github.com/fatih/color v1.5.0"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/fsnotify/fsnotify 4da3e2cfbabc9f751898f250b49f2439785783a1"
	"github.com/hashicorp/hcl 23c074d0eceb2b8a5bfdbb271ab780cde70f05a8"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/jinzhu/gorm 5174cc5c242a728b435ea2be8a2f7f998e15429b"
	"github.com/jinzhu/inflection 1c35d901db3da928c72a72d8458480cc9ade058f"
	"github.com/lib/pq 83612a56d3dd153a94a629cd64925371c9adad78"
	"github.com/magiconair/properties 49d762b9817ba1c2e9d0c69183c2b4a8b8f1d934"
	"github.com/mattn/go-colorable 5411d3eea5978e6cdc258b30de592b60df6aba96"
	"github.com/mattn/go-isatty 57fdcb988a5c543893cc61bce354a6e24ab70022"
	"github.com/mitchellh/mapstructure 06020f85339e21b2478f756a78e295255ffa4d6a"
	"github.com/pelletier/go-toml 0131db6d737cfbbfb678f8b7d92e55e27ce46224"
	"github.com/spf13/afero 57afd63c68602b63ed976de00dd066ccb3c319db"
	"github.com/spf13/cast v1.1.0"
	"github.com/spf13/cobra v0.0.1"
	"github.com/spf13/jwalterweatherman 12bd96e66386c1960ab0f74ced1362f66f552f7b"
	"github.com/spf13/pflag 4c012f6dcd9546820e378d0bdda4d8fc772cdfea"
	"github.com/spf13/viper v1.0.0"
	"golang.org/x/sys e24f485414aeafb646f6fca458b0bf869c0880a1 github.com/golang/sys"
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
	GOPATH="${S}" go build -mod vendor -v -ldflags "-X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=${PV}" -o ${PN} . || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/${PN}
	insinto /etc/kube-bench
	doins -r src/${EGO_PN}/cfg
}
