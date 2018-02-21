# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=(
	"golang.org/x/tools a4ae70923768403983fdab4e1d612d79c08ba465 github.com/golang/tools"
	"github.com/fsnotify/fsnotify c2828203cd70a50dcccfb2761f8b1f8ceef9a8e9"
	"github.com/golang/glog 23def4e6c14b4da8ac2ed8007337bc5eb5007998"
	"github.com/pkg/errors 30136e27e2ac8d167177e8a583aa4c3fea5be833"
	"github.com/spf13/afero bbf41cb36dffe15dff5bf7e18c447801e7ffe163"
	"golang.org/x/sys 37707fdb30a5b38865cfb95e5aab41707daec7fd github.com/golang/sys"
	"golang.org/x/text 4e4a3210bb54bb31f6ab2cdca2edcc0b50c420c1 github.com/golang/text"
	)

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"
EGIT_COMMIT="04017b5a1241b4e78b0a2dab84e5a332228b54d2"
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
