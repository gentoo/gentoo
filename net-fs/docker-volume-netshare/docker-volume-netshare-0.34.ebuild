# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/ContainX/docker-volume-netshare"
EGIT_COMMIT="v${PV}"

EGO_VENDOR=( "github.com/Sirupsen/logrus 85b1699d505667d13f8ac4478c1debbf85d6c5de"
	"github.com/dickeyxxx/netrc 3acf1b3de25d89c7688c63bb45f6b07f566555ec"
	"github.com/docker/go-plugins-helpers 021fd77358602b2c20fc3a1dfd260fd0dace4f53"
	"github.com/coreos/go-systemd 24036eb3df68550d24a2736c5d013f4e83366866"
	"github.com/docker/go-connections e15c02316c12de00874640cd76311849de2aeed5"
	"github.com/miekg/dns e78414ef75607394ad7d917824f07f381df2eafa"
	"github.com/spf13/cobra b4dbd37a01839e0653eec12aa4bbb2a2ce7b2a37"
	"github.com/spf13/pflag e57e3eeb33f795204c1ca35f56c44f83227c6e66"
	"golang.org/x/net dfe83d419c9403b40b19d08cdba2afec27b002f7 github.com/golang/net"
	"github.com/coreos/pkg 8dbaa491b063ed47e2474b5363de0c0db91cf9f2"
	"golang.org/x/crypto 850760c427c516be930bc91280636328f1a62286 github.com/golang/crypto"
)

inherit golang-vcs-snapshot systemd user

SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
DESCRIPTION="Docker NFS, AWS EFS, Ceph & Samba/CIFS Volume Plugin"
HOMEPAGE="https://github.com/ContainX/docker-volume-netshare"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

src_prepare() {
	default
	sed -i -e "s/dmaj/ContainX/" -e "s/VERSION string = \"\"/VERSION string =\"${PV}\"/" src/${EGO_PN}/main.go || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	CGO_LDFLAGS="-fno-PIC" GOPATH="${S}" go build || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin ${PN}
	dodoc README.md
	popd || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
