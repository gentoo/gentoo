# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/aquasecurity/kube-bench"

EGO_VENDOR=( "github.com/fatih/color 5df930a27be2502f99b292b7cc09ebad4d0891f4"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/jinzhu/gorm 0a51f6cdc55d1650d9ed3b4c13026cfa9133b01e"
	"github.com/jinzhu/inflection 1c35d901db3da928c72a72d8458480cc9ade058f"
	"github.com/lib/pq 83612a56d3dd153a94a629cd64925371c9adad78"
	"github.com/spf13/cobra ccaecb155a2177302cb56cae929251a256d0f646"
	"github.com/spf13/pflag 4c012f6dcd9546820e378d0bdda4d8fc772cdfea"
	"github.com/fsnotify/fsnotify 4da3e2cfbabc9f751898f250b49f2439785783a1"
	"github.com/hashicorp/hcl 23c074d0eceb2b8a5bfdbb271ab780cde70f05a8"
	"github.com/magiconair/properties 49d762b9817ba1c2e9d0c69183c2b4a8b8f1d934"
	"github.com/mitchellh/mapstructure 06020f85339e21b2478f756a78e295255ffa4d6a"
	"github.com/pelletier/go-toml 4e9e0ee19b60b13eb79915933f44d8ed5f268bdd"
	"github.com/spf13/afero 8d919cbe7e2627e417f3e45c3c0e489a5b7e2536"
	"github.com/spf13/cast acbeb36b902d72a7a4c18e8f3241075e7ab763e4"
	"github.com/spf13/jwalterweatherman 12bd96e66386c1960ab0f74ced1362f66f552f7b"
	"github.com/spf13/viper 1a0c4a370c3e8286b835467d2dfcdaf636c3538b"
	"golang.org/x/sys b8f5ef32195cae6470b728e8ca677f0dbed1a004 github.com/golang/sys"
	"golang.org/x/text 3b24cac7bc3a458991ab409aa2a339ac9e0d60d6 github.com/golang/text"
	"gopkg.in/yaml.v2 287cf08546ab5e7e37d55a84f7ed3fd1db036de5 github.com/go-yaml/yaml" )

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
	GOPATH="${S}" go build -o ${PN} . || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/${PN}
	insinto /etc/kube-bench
	doins -r src/${EGO_PN}/cfg
}
