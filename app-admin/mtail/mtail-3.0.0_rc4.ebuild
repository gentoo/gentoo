# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "golang.org/x/tools f57adc18217d779aa42266ea71a545827755a77b github.com/golang/tools"
	"github.com/fsnotify/fsnotify 4da3e2cfbabc9f751898f250b49f2439785783a1"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/pkg/errors 2b3a18b5f0fb6b4f9190549597d3f962c02bc5eb"
	"github.com/spf13/afero e67d870304c4bca21331b02f414f970df13aa694"
	"golang.org/x/sys 43eea11bc92608addb41b8a406b0407495c106f6 github.com/golang/sys"
	"golang.org/x/text 825fc78a2fd6fa0a5447e300189e3219e05e1f25 github.com/golang/text"
	)

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"
EGIT_COMMIT="d9f2afc03ae86e203892f25d66cce8c76df8c649"
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
