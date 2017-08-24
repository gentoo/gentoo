# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/coreos/zetcd"

EGO_VENDOR=( "github.com/coreos/etcd 714e7ec8db7f8398880197be10771fe89c480ee5"
	"google.golang.org/grpc 777daa17ff9b5daef1cfdf915088a2ada3332bf0 github.com/grpc/grpc-go"
	"github.com/golang/protobuf 4bd1920723d7b7c925de087aa32e2187708897f7"
	"google.golang.org/genproto ee236bd376b077c7a89f260c026c4735b195e459 github.com/google/go-genproto"
)

ZETCD_COMMIT="e4352ce3cc940bc5b60bb3dd69c14f16dac2980a"

inherit golang-build golang-vcs-snapshot user

ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A ZooKeeper personality for etcd"
HOMEPAGE="https://github.com/coreos/zetcd"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_compile() {
	pushd src || die
	GOPATH="${WORKDIR}/${P}" go build -o ${EGO_PN}/bin/zetcd -v \
		-ldflags "-X ${EGO_PN}/version.Version=${PV} -X ${EGO_PN}/version.SHA=$ZETCD_COMMIT" \
		${EGO_PN}/cmd/zetcd || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/bin/*
	dodoc src/${EGO_PN}/README.md
	keepdir /var/log/zetcd
	fowners -R ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
