# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit golang-base

KEYWORDS="~amd64"
DESCRIPTION="KVM driver for docker-machine"
EGO_PN="github.com/dhiltgen/${PN}/..."
HOMEPAGE="http://${EGO_PN%/*}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
COMMON_DEPEND="app-emulation/libvirt:=[qemu,virt-network]"
DEPEND=">=dev-lang/go-1.6:=
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rgbkrk/libvirt-go/archive/v2.13.0.tar.gz -> libvirt-go-2.13.0.tar.gz
	https://github.com/docker/machine/archive/v0.8.2.tar.gz -> docker-machine-0.8.2.tar.gz"

get_archive_go_package() {
	local archive=${1} uri x
	for x in ${SRC_URI}; do
		if [[ ${x} == http* ]]; then
			uri=${x}
		elif [[ ${x} == ${archive} ]]; then
			break
		fi
	done
	uri=${uri#https://}
	echo ${uri%/archive/*}
}

unpack_go_packages() {
	local go_package x
	# Unpack packages to appropriate locations for GOPATH
	for x in ${A}; do
		unpack ${x}
		if [[ ${x} == *.tar.gz ]]; then
			go_package=$(get_archive_go_package ${x})
			mkdir -p src/${go_package%/*}
			mv ${go_package##*/}-* src/${go_package} || die
		fi
	done
}

src_unpack() {
	mkdir "${S}" && cd "${S}" || die
	unpack_go_packages
}

src_prepare() {
	eapply_user
	sed -e 's|alexzorin|rgbkrk|g' -i src/${EGO_PN%/*}/kvm.go || die
}

src_compile() {
	export GOPATH=${S}
	cd "${S}"/src/${EGO_PN%/*}/bin || die
	emake || die
}

src_install() {
	dobin "${S}/src/${EGO_PN%/*}/bin/${PN/kvm/driver-kvm}"
	dodoc "${S}/src/${EGO_PN%/*}/README.md"
}
