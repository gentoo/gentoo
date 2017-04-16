# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/ContainX/docker-volume-netshare/..."
EGIT_COMMIT="4bfe7ba0572ee9d135dd59924548a37b1ab2af66"

EGO_VENDOR=( "github.com/Sirupsen/logrus 10f801ebc38b33738c9d17d50860f484a0988ff5"
	"github.com/dickeyxxx/netrc 3acf1b3de25d89c7688c63bb45f6b07f566555ec"
	"github.com/docker/go-plugins-helpers 8af45ff6ad5b7608853de51133c33e6638b02134"
	"github.com/coreos/go-systemd 1f9909e51b2dab2487c26d64c8f2e7e580e4c9f5"
	"github.com/docker/go-connections e15c02316c12de00874640cd76311849de2aeed5"
	"github.com/miekg/dns 6ebcb714d36901126ee2807031543b38c56de963"
	"github.com/spf13/cobra 5deb57bbca49eb370538fc295ba4b2988f9f5e09"
	"github.com/spf13/pflag e453343e6260b4a3a89f1f0e10a2fbb07f8d9750"
	"golang.org/x/net 5602c733f70afc6dcec6766be0d5034d4c4f14de github.com/golang/net"
	"github.com/coreos/pkg 099530d80109cc4876ac866c38dded19786731d0"
	"golang.org/x/crypto cbc3d0884eac986df6e78a039b8792e869bff863 github.com/golang/crypto"
	)

inherit golang-vcs-snapshot systemd user

SRC_URI="https://${EGO_PN%/*}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
DESCRIPTION="Docker NFS, AWS EFS, Ceph & Samba/CIFS Volume Plugin"
HOMEPAGE="https://github.com/ContainX/docker-volume-netshare"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

src_prepare() {
	default
	sed -i -e "s/VERSION string = \"\"/VERSION string =\"${PV}\"/" src/${EGO_PN%/*}/main.go || die
}

src_compile() {
	pushd src/${EGO_PN%/*} || die
	CGO_LDFLAGS="-fno-PIC" GOPATH="${S}" go build || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN%/*} || die
	dobin ${PN}
	dodoc README.md
	popd || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
