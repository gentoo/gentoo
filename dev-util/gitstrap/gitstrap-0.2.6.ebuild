# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_VENDOR=(
	"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml"
	"github.com/g4s8/gopwd 0ddc5d340ba563bdfa83c629ac37458aeea97e4b"
	"github.com/google/go-github a01ea50f2fc0ce93dad509f31ed1b279cc07b424"
	"golang.org/x/oauth2 0f29369cfe4552d0e4bcddc57cc75f4d7e672a33 github.com/golang/oauth2"
	"golang.org/x/net c5a3c61f89f3ed696ec36b629ef1b97541165225 github.com/golang/net"
	"github.com/google/go-querystring c8c88dbee036db4e4808d1f2ec8c2e15e11c3f80"
	"golang.org/x/crypto a832865fa7ada6126f4c6124ac49f71be71bff2a github.com/golang/crypto"
)

inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/g4s8/${PN}"
DESCRIPTION="Command line tool to bootstrap Github repository"
HOMEPAGE="https://github.com/g4s8/${PN}"
SRC_URI="https://github.com/g4s8/${PN}/archive/${PN}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	BUILDFLAGS="" GOPATH="${S}" \
		emake BUILD_VERSION=${PV} BUILD_DATE="2019.09.30T11:31:00" -j1 -C src/${EGO_PN} build
}

src_test() {
	emake OUTPUT=lib test
}

src_install() {
	dobin src/${EGO_PN}/${PN} || die
}
