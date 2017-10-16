# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "golang.org/x/tools 68e087e2a5786de2c035ed544b1c5a42e31f1933 github.com/golang/tools"
	"github.com/fsnotify/fsnotify 4da3e2cfbabc9f751898f250b49f2439785783a1"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/pkg/errors 2b3a18b5f0fb6b4f9190549597d3f962c02bc5eb"
	"github.com/spf13/afero ee1bd8ee15a1306d1f9201acc41ef39cd9f99a1b"
	"golang.org/x/sys 314a259e304ff91bd6985da2a7149bbf91237993 github.com/golang/sys"
	"golang.org/x/text 1cbadb444a806fd9430d14ad08967ed91da4fa0a github.com/golang/text" )

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"
EGIT_COMMIT="5e6d38908091a8648c0f26c44ebd708e241f3814"
EGO_PN="github.com/google/mtail"
SRC_URI="https://${EGO_PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
DESCRIPTION="A tool for extracting metrics from application logs"
HOMEPAGE="https://github.com/google/mtail"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
RDEPEND="!app-misc/mtail"

RESTRICT="test"

src_prepare() {
	default
	sed -i -e '/^[[:space:]]*go get .*/d'\
		-e "s/git describe --tags/echo ${PV}/"\
		-e "s/git rev-parse HEAD/echo ${EGIT_COMMIT}/"\
		"src/${EGO_PN}/Makefile" || die
}

src_compile() {
	export GOPATH="${S}"
	go install -v -work -x ${EGO_BUILD_FLAGS} "${EGO_PN}/vendor/golang.org/x/tools/cmd/goyacc" || die
	emake -C "src/${EGO_PN}"
}

src_install() {
	dobin bin/mtail
	dodoc "src/${EGO_PN}/"{CONTRIBUTING.md,README.md,TODO}
}
