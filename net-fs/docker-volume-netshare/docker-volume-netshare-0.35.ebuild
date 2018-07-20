# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/ContainX/docker-volume-netshare"
EGIT_COMMIT="v${PV}"

EGO_VENDOR=( "github.com/Sirupsen/logrus 8c0189d9f6bbf301e5d055d34268156b317016af"
	"github.com/dickeyxxx/netrc e1a19c977509b96a5c76996dec63ab5aac67c38c"
	"github.com/docker/go-plugins-helpers 61cb8e2334204460162c8bd2417cd43cb71da66f"
	"github.com/coreos/go-systemd 25fe332a900022d06a189ce01108392854c59df1"
	"github.com/docker/go-connections 7beb39f0b969b075d1325fecb092faf27fd357b6"
	"github.com/miekg/dns 5364553f1ee9cddc7ac8b62dce148309c386695b"
	"github.com/spf13/cobra be77323fc05148ef091e83b3866c0d47c8e74a8b"
	"github.com/spf13/pflag ee5fd03fd6acfd43e44aea0b4135958546ed8e73"
	"golang.org/x/net cbe0f9307d0156177f9dd5dc85da1a31abc5f2fb github.com/golang/net"
	"golang.org/x/crypto 432090b8f568c018896cd8a0fb0345872bbac6ce github.com/golang/crypto"
	"golang.org/x/sys 37707fdb30a5b38865cfb95e5aab41707daec7fd github.com/golang/sys"
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
