# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Generate Custrom Resource Definitions for Kubernetes"
HOMEPAGE="https://github.com/kubernetes-sigs/controller-tools"

S="${WORKDIR}/controller-tools-${PV}"
EGO_VENDOR=(
	"github.com/google/gofuzz v1.0.0"
	"github.com/gogo/protobuf v1.3.1"
	"github.com/golang/protobuf v1.3.1"
	"github.com/fatih/color v1.7.0"
	"github.com/google/go-cmp v0.3.0"
	"github.com/mattn/go-colorable v0.1.2"
	"gopkg.in/inf.v0 v0.9.1 github.com/go-inf/inf"
	"github.com/gobuffalo/flect v0.1.5"
	"github.com/onsi/ginkgo v1.8.0"
	"github.com/onsi/gomega v1.5.0"
	"github.com/spf13/afero v1.2.2"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/pflag v1.0.3"
	"github.com/mattn/go-isatty v0.0.10"
	"golang.org/x/net 3b0461eec859c4b73bb64fdc8285971fd33e3938 github.com/golang/net"
	"golang.org/x/sys d432491b91382bba9c2a91776aa47c9430183a6f github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/tools 58d531046acdc757f177387bc1725bfa79895d69 github.com/golang/tools"
	"gopkg.in/yaml.v3 4206685974f28e3178b35fa198a59899aa4dee3a github.com/go-yaml/yaml"
	"gopkg.in/yaml.v2 v2.2.7 github.com/go-yaml/yaml"
	"sigs.k8s.io/yaml v1.1.0 github.com/kubernetes-sigs/yaml"
	"k8s.io/klog v0.4.0 github.com/kubernetes/klog"
	"k8s.io/kube-openapi 743ec37842bf github.com/kubernetes/kube-openapi"
	"k8s.io/api 95b840bb6a1f github.com/kubernetes/api"
	"k8s.io/apiextensions-apiserver 8f644eb6e783 github.com/kubernetes/apiextensions-apiserver"
	"k8s.io/apimachinery 27d36303b655 github.com/kubernetes/apimachinery"
	"k8s.io/utils 581e00157fb1 github.com/kubernetes/utils"
)

SRC_URI="https://github.com/kubernetes-sigs/controller-tools/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD-4 ECL-2.0 JSON MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

DOCS=README.md

src_compile() {
	GOCACHE="${T}/go-cache" go build \
		-o "bin/${PN}" "./cmd/${PN}" || die
}

src_install() {
	dobin "bin/${PN}"
	einstalldocs
}
