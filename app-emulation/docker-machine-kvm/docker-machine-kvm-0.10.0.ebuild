# Copyright 1999-2019 Gentoo Authors
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

HOMEPAGE="https://github.com/dhiltgen/docker-machine-kvm"
LICENSE="Apache-2.0 BSD CC-BY-SA-4.0 MIT MPL-2.0 ZLIB"
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
	emake build
}

src_install() {
	dobin "${S}/src/${EGO_PN}/cmd/${PN/kvm/driver-kvm}/${PN/kvm/driver-kvm}"
	dodoc "${S}/src/${EGO_PN}/README.md"
}
