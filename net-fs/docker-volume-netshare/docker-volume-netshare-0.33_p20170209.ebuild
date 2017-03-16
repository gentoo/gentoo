# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/ContainX/docker-volume-netshare/..."
EGIT_COMMIT="4bfe7ba0572ee9d135dd59924548a37b1ab2af66"

EGO_VENDOR=( "github.com/Sirupsen/logrus 547e984ad93a90192134fc0fdb57a468edb514fe"
	"github.com/dickeyxxx/netrc 3acf1b3de25d89c7688c63bb45f6b07f566555ec"
	"github.com/docker/go-plugins-helpers 8af45ff6ad5b7608853de51133c33e6638b02134"
	"github.com/coreos/go-systemd c4308da792903734bd95f877255249cef0862886"
	"github.com/docker/go-connections a2afab9802043837035592f1c24827fb70766de9"
	"github.com/miekg/dns c862b7e359850847d4945cce311db2ea90cab7c0"
	"github.com/spf13/cobra 7be4beda01ec05d0b93d80b3facd2b6f44080d94"
	"github.com/spf13/pflag 9ff6c6923cfffbcd502984b8e0c80539a94968b7"
	"golang.org/x/net a6577fac2d73be281a500b310739095313165611 github.com/golang/net"
	"github.com/coreos/pkg 1c941d73110817a80b9fa6e14d5d2b00d977ce2a"
	"golang.org/x/crypto 728b753d0135da6801d45a38e6f43ff55779c5c2 github.com/golang/crypto"
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
