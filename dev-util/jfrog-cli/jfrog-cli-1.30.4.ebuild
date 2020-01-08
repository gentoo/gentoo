# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=(
	"github.com/buger/jsonparser 6acdf747ae99cad92d1e8134606008acaca71844"
	"github.com/chzyer/readline 2972be24d48e78746da79ba8e24e8b488c9880de"
	"github.com/codegangsta/cli v1.20.0"
	"github.com/danwakefield/fnmatch cbb64ac3d964b81592e64f957ad53df015803288"
	"github.com/denormal/go-gitignore ae8ad1d07817b3d3b49cabb21559a3f493a357a3"
	"github.com/dsnet/compress cc9eb1d7ad760af14e8f918698f745e80377af4f"
	"github.com/emirpasic/gods v1.12.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/golang/snappy 2e65f85255dbc3072edf28d6b5b8efc472979f5a"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/jbenet/go-context d14ea06fba99483203c19d92cfcd13ebe73135f4"
	"github.com/jfrog/gocmd v0.1.11"
	"github.com/jfrog/gofrog v1.0.5"
	"github.com/jfrog/jfrog-client-go v0.5.8"
	"github.com/kevinburke/ssh_config 81db2a75821ed34e682567d48be488a1c3121088"
	"github.com/magiconair/properties v1.8.0"
	"github.com/mattn/go-shellwords v1.0.3"
	"github.com/mholt/archiver v2.1.0"
	"github.com/mitchellh/go-homedir v1.0.0"
	"github.com/mitchellh/mapstructure v1.0.0"
	"github.com/nwaples/rardecode e06696f847aeda6f39a8f0b7cdff193b7690aef6"
	"github.com/pelletier/go-buffruneio v0.2.0"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/pierrec/lz4 v2.0.5"
	"github.com/pkg/errors v0.8.1"
	"github.com/sergi/go-diff v1.0.0"
	"github.com/spf13/afero v1.1.2"
	"github.com/spf13/cast v1.2.0"
	"github.com/spf13/jwalterweatherman v1.0.0"
	"github.com/spf13/pflag v1.0.2"
	"github.com/spf13/viper v1.2.1"
	"github.com/src-d/gcfg v1.3.0"
	"github.com/ulikunitz/xz v0.5.4"
	"github.com/vbauerster/mpb v4.7.0"
	"github.com/VividCortex/ewma v1.1.1"
	"github.com/xanzy/ssh-agent v0.2.0"
	"golang.org/x/crypto a29dc8fdc73485234dbef99ebedb95d2eced08de github.com/golang/crypto"
	"golang.org/x/net eb5bcb51f2a31c7d5141d810b70815c05d9c9146 github.com/golang/net"
	"golang.org/x/sys d89cdac9e8725f2aefce25fcbfef41134c9ad412 github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
	"gopkg.in/src-d/go-billy.v4 v4.3.0 github.com/src-d/go-billy"
	"gopkg.in/src-d/go-git.v4 v4.7.0 github.com/src-d/go-git"
	"gopkg.in/warnings.v0 v0.1.2 github.com/go-warnings/warnings"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
)

inherit golang-vcs-snapshot

EGO_PN=github.com/jfrog/jfrog-cli
DESCRIPTION="Command line utility foroperations on container images and image repositories"
HOMEPAGE="https://github.com/jfrog/jfrog-cli"

SRC_URI="https://github.com/jfrog/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND=""
DEPEND=""

S=${WORKDIR}/${P}/src/${EGO_PN}

src_prepare() {
	default

	#701188 go-module.eclass does not support versioned import paths.
	rm go.mod || die
	grep -rlZ 'github.com/vbauerster/mpb/v4' . | \
		xargs -0 sed -i -e 's|github.com/vbauerster/mpb/v4|github.com/vbauerster/mpb|' || die
	grep -rlZ 'github.com/jfrog/jfrog-cli-go' . | \
		xargs -0 sed -i -e 's|github.com/jfrog/jfrog-cli-go|github.com/jfrog/jfrog-cli|' || die
}

src_compile() {
	export GO111MODULE=off GOPATH=${WORKDIR}/${P}
	export -n GOCACHE XDG_CACHE_HOME
	./build.sh || die
}

src_install() {
	dobin jfrog
	einstalldocs
}
