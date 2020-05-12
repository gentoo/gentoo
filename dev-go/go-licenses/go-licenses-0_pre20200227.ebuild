# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Reports on the licenses used by a Go package and its dependencies"
HOMEPAGE="https://github.com/google/go-licenses"
LICENSE="Apache-2.0 MIT BSD BSD-2"
SLOT="0"

EGO_PN=github.com/google/${PN}
EGIT_REPO_URI="https://${EGO_PN}.git"

inherit go-module

if [[ ${PV} == *9999* ]]; then
	inherit git-r3

	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="0fa8c766a59182ce9fd94169ddb52abe568b7f4e"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

	EGO_SUM=(
		"github.com/alcortesm/tgz v0.0.0-20161220082320-9c5fe88206d7"
		"github.com/anmitsu/go-shlex v0.0.0-20161002113705-648efa622239"
		"github.com/armon/go-socks5 v0.0.0-20160902184237-e75332964ef5"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/emirpasic/gods v1.12.0"
		"github.com/flynn/go-shlex v0.0.0-20150515145356-3f9db97f8568"
		"github.com/gliderlabs/ssh v0.2.2"
		"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b"
		"github.com/google/go-cmp v0.3.1"
		"github.com/google/licenseclassifier v0.0.0-20190926221455-842c0d70d702"
		"github.com/inconshreveable/mousetrap v1.0.0"
		"github.com/jbenet/go-context v0.0.0-20150711004518-d14ea06fba99"
		"github.com/kevinburke/ssh_config v0.0.0-20190725054713-01f96b0aa0cd"
		"github.com/kr/pretty v0.1.0"
		"github.com/kr/text v0.1.0"
		"github.com/mitchellh/go-homedir v1.1.0"
		"github.com/otiai10/copy v1.0.2"
		"github.com/otiai10/curr v0.0.0-20150429015615-9b4961190c95"
		"github.com/otiai10/mint v1.3.0"
		"github.com/pkg/errors v0.8.1"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/sergi/go-diff v1.0.0"
		"github.com/spf13/cobra v0.0.5"
		"github.com/spf13/pflag v1.0.5"
		"github.com/src-d/gcfg v1.4.0"
		"github.com/stretchr/testify v1.3.0"
		"github.com/xanzy/ssh-agent v0.2.1"
		"golang.org/x/crypto v0.0.0-20190701094942-4def268fd1a4"
		"golang.org/x/crypto v0.0.0-20191117063200-497ca9f6d64f"
		"golang.org/x/net v0.0.0-20190724013045-ca1201d0de80"
		"golang.org/x/net v0.0.0-20191119073136-fc4aabc6c914"
		"golang.org/x/sys v0.0.0-20190726091711-fc99dfbffb4e"
		"golang.org/x/sys v0.0.0-20191119060738-e882bf8e40c2"
		"golang.org/x/text v0.3.2"
		"golang.org/x/tools v0.0.0-20191118222007-07fc4c7f2b98"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
		"gopkg.in/src-d/go-billy.v4 v4.3.2"
		"gopkg.in/src-d/go-git-fixtures.v3 v3.5.0"
		"gopkg.in/src-d/go-git.v4 v4.13.1"
		"gopkg.in/warnings.v0 v0.1.2"

		"github.com/BurntSushi/toml v0.3.1/go.mod"
		"github.com/alcortesm/tgz v0.0.0-20161220082320-9c5fe88206d7/go.mod"
		"github.com/anmitsu/go-shlex v0.0.0-20161002113705-648efa622239/go.mod"
		"github.com/armon/consul-api v0.0.0-20180202201655-eb2c6b5be1b6/go.mod"
		"github.com/armon/go-socks5 v0.0.0-20160902184237-e75332964ef5/go.mod"
		"github.com/coreos/etcd v3.3.10+incompatible/go.mod"
		"github.com/coreos/go-etcd v2.0.0+incompatible/go.mod"
		"github.com/coreos/go-semver v0.2.0/go.mod"
		"github.com/cpuguy83/go-md2man v1.0.10/go.mod"
		"github.com/creack/pty v1.1.7/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/emirpasic/gods v1.12.0/go.mod"
		"github.com/flynn/go-shlex v0.0.0-20150515145356-3f9db97f8568/go.mod"
		"github.com/fsnotify/fsnotify v1.4.7/go.mod"
		"github.com/gliderlabs/ssh v0.2.2/go.mod"
		"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
		"github.com/google/go-cmp v0.2.0/go.mod"
		"github.com/google/go-cmp v0.3.0/go.mod"
		"github.com/google/go-cmp v0.3.1/go.mod"
		"github.com/google/licenseclassifier v0.0.0-20190926221455-842c0d70d702/go.mod"
		"github.com/hashicorp/hcl v1.0.0/go.mod"
		"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
		"github.com/jbenet/go-context v0.0.0-20150711004518-d14ea06fba99/go.mod"
		"github.com/jessevdk/go-flags v1.4.0/go.mod"
		"github.com/kevinburke/ssh_config v0.0.0-20190725054713-01f96b0aa0cd/go.mod"
		"github.com/kr/pretty v0.1.0/go.mod"
		"github.com/kr/pty v1.1.1/go.mod"
		"github.com/kr/pty v1.1.8/go.mod"
		"github.com/kr/text v0.1.0/go.mod"
		"github.com/magiconair/properties v1.8.0/go.mod"
		"github.com/mitchellh/go-homedir v1.1.0/go.mod"
		"github.com/mitchellh/mapstructure v1.1.2/go.mod"
		"github.com/otiai10/copy v1.0.2/go.mod"
		"github.com/otiai10/curr v0.0.0-20150429015615-9b4961190c95/go.mod"
		"github.com/otiai10/mint v1.3.0/go.mod"
		"github.com/pelletier/go-buffruneio v0.2.0/go.mod"
		"github.com/pelletier/go-toml v1.2.0/go.mod"
		"github.com/pkg/errors v0.8.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/russross/blackfriday v1.5.2/go.mod"
		"github.com/sergi/go-diff v1.0.0/go.mod"
		"github.com/spf13/afero v1.1.2/go.mod"
		"github.com/spf13/cast v1.3.0/go.mod"
		"github.com/spf13/cobra v0.0.5/go.mod"
		"github.com/spf13/jwalterweatherman v1.0.0/go.mod"
		"github.com/spf13/pflag v1.0.3/go.mod"
		"github.com/spf13/pflag v1.0.5/go.mod"
		"github.com/spf13/viper v1.3.2/go.mod"
		"github.com/src-d/gcfg v1.4.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.2.0/go.mod"
		"github.com/stretchr/testify v1.2.2/go.mod"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"github.com/ugorji/go/codec v0.0.0-20181204163529-d75b2dcb6bc8/go.mod"
		"github.com/xanzy/ssh-agent v0.2.1/go.mod"
		"github.com/xordataexchange/crypt v0.0.3-0.20170626215501-b2862e3d0a77/go.mod"
		"golang.org/x/crypto v0.0.0-20181203042331-505ab145d0a9/go.mod"
		"golang.org/x/crypto v0.0.0-20190219172222-a4c6cb3142f2/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/crypto v0.0.0-20190701094942-4def268fd1a4/go.mod"
		"golang.org/x/crypto v0.0.0-20191117063200-497ca9f6d64f/go.mod"
		"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
		"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
		"golang.org/x/net v0.0.0-20190724013045-ca1201d0de80/go.mod"
		"golang.org/x/net v0.0.0-20191119073136-fc4aabc6c914/go.mod"
		"golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
		"golang.org/x/sys v0.0.0-20181205085412-a5c9d58dba9a/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20190221075227-b4e8571b14e0/go.mod"
		"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
		"golang.org/x/sys v0.0.0-20190726091711-fc99dfbffb4e/go.mod"
		"golang.org/x/sys v0.0.0-20191119060738-e882bf8e40c2/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.2/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20190729092621-ff9f1409240a/go.mod"
		"golang.org/x/tools v0.0.0-20191118222007-07fc4c7f2b98/go.mod"
		"golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
		"gopkg.in/src-d/go-billy.v4 v4.3.2/go.mod"
		"gopkg.in/src-d/go-git-fixtures.v3 v3.5.0/go.mod"
		"gopkg.in/src-d/go-git.v4 v4.13.1/go.mod"
		"gopkg.in/warnings.v0 v0.1.2/go.mod"
		"gopkg.in/yaml.v2 v2.2.2/go.mod"
	)

	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

go-module_set_globals
SRC_URI+=" ${EGO_SUM_SRC_URI}"

DEPEND="dev-go/licenseclassifier"
RDEPEND="${DEPEND}"

# tries to go online
RESTRICT="test"

src_prepare() {
	eapply_user

	local share="${EROOT}/usr/share/licenseclassifier"

	local vendored_const_path="vendor/github.com/google/licenseclassifier"
	if [[ ${PV} != *9999* ]]; then
		go mod vendor || die
	fi

	sed -i "s@= lcRoot()@= \"${share}\", error(nil)@" \
		"${vendored_const_path}"*/file_system_resources.go || die
}

src_compile() {
	mkdir build || die
	go build -o build ./... || die
}

src_test() {
	go test ./... || die
}

src_install() {
	dobin "build/${PN}"
	einstalldocs
}
