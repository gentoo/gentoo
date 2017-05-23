# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/dhiltgen/${PN}"
EGO_VENDOR=(
	"github.com/docker/machine v${PV}"
	"github.com/libvirt/libvirt-go c3209e4ba8b8dda65c85ca0ac04302e55895caf7"
)

inherit golang-build golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="KVM driver for docker-machine"

HOMEPAGE="http://${EGO_PN}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
COMMON_DEPEND="app-emulation/libvirt:=[qemu,virt-network]"
DEPEND=">=dev-lang/go-1.6:=
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

src_compile() {
	export GOPATH=${S}
	cd "${S}"/src/${EGO_PN}/cmd/${PN/kvm/driver-kvm} || die
	emake build || die
}

src_install() {
	dobin "${S}/src/${EGO_PN}/cmd/${PN/kvm/driver-kvm}/${PN/kvm/driver-kvm}"
	dodoc "${S}/src/${EGO_PN}/README.md"
}
