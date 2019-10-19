# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="SDK for building Kubernetes APIs using CRDs"
HOMEPAGE="https://book.kubebuilder.io"

EGO_VENDOR=(
	"github.com/gobuffalo/flect v0.1.5"
	"github.com/golang/protobuf v1.3.1"
	"github.com/onsi/ginkgo v1.8.0"
	"github.com/onsi/gomega v1.5.0"
	"github.com/spf13/afero v1.2.2"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/pflag v1.0.3"
	"golang.org/x/net 3b0461eec859c4b73bb64fdc8285971fd33e3938 github.com/golang/net"
	"golang.org/x/sys d432491b91382bba9c2a91776aa47c9430183a6f github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/tools 58d531046acdc757f177387bc1725bfa79895d69 github.com/golang/tools"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
)

SRC_URI="https://github.com/kubernetes-sigs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD-4 ECL-2.0 JSON MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( {DESIGN,README}.md )

src_compile() {
	GOCACHE="${T}/go-cache" go build \
		-o "bin/${PN}" ./cmd || die
}

src_install() {
	dobin bin/kubebuilder
	einstalldocs
}
