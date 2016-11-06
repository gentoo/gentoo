# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN="github.com/hyperhq/runv"

inherit autotools golang-vcs-snapshot

DESCRIPTION="Hypervisor-based Runtime for OCI"
HOMEPAGE="https://github.com/hyperhq/runv"
SRC_URI="https://github.com/hyperhq/runv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libvirt xen"

RDEPEND="libvirt? ( >=app-emulation/libvirt-1.2.2 )
	xen? ( app-emulation/xen )"
DEPEND="${RDEPEND}"

src_prepare() {
	pushd src/github.com/hyperhq/runv/ || die
	default
	eautoreconf
	popd
}

src_configure() {
	local myeconfargs=( $(use_with libvirt)
		$(use_with xen) )
	pushd src/github.com/hyperhq/runv/ || die
	econf "${myeconfargs[@]}"
	popd
}

src_compile() {
	GOPATH="${S}:$(get_golibdir_gopath)" emake -C src/github.com/hyperhq/runv/
}

src_install() {
	dodoc src/${EGO_PN}/README.md
	dobin src/${EGO_PN}/runv
}
