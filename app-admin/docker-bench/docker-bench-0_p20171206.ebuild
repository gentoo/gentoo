# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/aquasecurity/docker-bench"

EGO_VENDOR=(
"github.com/aquasecurity/bench-common fc47834ad19bafbba64ded876d82bee4dba50c40"
"github.com/fatih/color 5df930a27be2502f99b292b7cc09ebad4d0891f4"
"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
"github.com/spf13/cobra 93959269ad99e80983c9ba742a7e01203a4c0e4f"
"github.com/spf13/pflag 4c012f6dcd9546820e378d0bdda4d8fc772cdfea"
"github.com/spf13/viper aafc9e6bc7b7bb53ddaa75a5ef49a17d6e654be5"
"github.com/fsnotify/fsnotify c2828203cd70a50dcccfb2761f8b1f8ceef9a8e9"
"github.com/hashicorp/hcl 23c074d0eceb2b8a5bfdbb271ab780cde70f05a8"
"github.com/magiconair/properties 49d762b9817ba1c2e9d0c69183c2b4a8b8f1d934"
"github.com/mitchellh/mapstructure a4e142e9c047c904fa2f1e144d9a84e6133024bc"
"github.com/pelletier/go-toml acdc4509485b587f5e675510c4f2c63e90ff68a8"
"github.com/spf13/afero bb8f1927f2a9d3ab41c9340aa034f6b803f4359c"
"github.com/spf13/cast acbeb36b902d72a7a4c18e8f3241075e7ab763e4"
"github.com/spf13/jwalterweatherman 7c0cea34c8ece3fbeb2b27ab9b59511d360fb394"
"golang.org/x/sys 37707fdb30a5b38865cfb95e5aab41707daec7fd github.com/golang/sys"
"golang.org/x/text 4e4a3210bb54bb31f6ab2cdca2edcc0b50c420c1 github.com/golang/text"
"gopkg.in/yaml.v2 d670f9405373e636a5a2765eea47fac0c9bc91a4 github.com/go-yaml/yaml"
)
EGIT_COMMIT="8abecdea32bc3fe271eed1848b3e77ab46dd1971"

inherit golang-build golang-vcs-snapshot bash-completion-r1
ARCHIVE_URI="https://github.com/aquasecurity/docker-bench/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Docker Bench for Security runs the CIS Docker Benchmark"
HOMEPAGE="https://github.com/aquasecurity/docker-bench"
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
	insinto /etc/docker-bench/
	doins -r src/${EGO_PN}/cfg
}
