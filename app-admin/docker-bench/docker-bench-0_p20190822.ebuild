# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/aquasecurity/docker-bench"

EGO_VENDOR=(
	"github.com/aquasecurity/bench-common 81f08528fa03"
	"github.com/fatih/color v1.7.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/golang/glog 23def4e6c14b"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/magiconair/properties v1.8.0"
	"github.com/mattn/go-colorable v0.1.2"
	"github.com/mattn/go-isatty v0.0.8"
	"github.com/mitchellh/mapstructure v1.1.2"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/spf13/afero v1.1.2"
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/cobra v0.0.5"
	"github.com/spf13/jwalterweatherman v1.0.0"
	"github.com/spf13/pflag v1.0.3"
	"github.com/spf13/viper v1.4.0"
	"golang.org/x/sys a9d3bda3a223 github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
)

EGIT_COMMIT="67d07bbe0bc22b73344b6a24ae810294c0912165"

inherit golang-build golang-vcs-snapshot bash-completion-r1
ARCHIVE_URI="https://github.com/aquasecurity/docker-bench/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Docker Bench for Security runs the CIS Docker Benchmark"
HOMEPAGE="https://github.com/aquasecurity/docker-bench"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GO111MODULE=on GOPATH="${S}" go build -mod vendor -o ${PN} . || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/${PN}
	insinto /etc/docker-bench/
	doins -r src/${EGO_PN}/cfg
}
