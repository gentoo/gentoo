# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGO_PN="github.com/hyperhq/hyperd"

inherit autotools systemd golang-vcs-snapshot

DESCRIPTION="Hypervisor-based Runtime for OCI"
HOMEPAGE="https://github.com/hyperhq/hyperd"
SRC_URI="https://github.com/hyperhq/hyperd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libvirt xen"

RDEPEND="libvirt? ( >=app-emulation/libvirt-1.2.2 )
	xen? ( app-emulation/xen )"
DEPEND="${RDEPEND}
	sys-fs/lvm2"

src_prepare() {
	pushd src/${EGO_PN} || die
	default
	eautoreconf
	popd
}

src_configure() {
	local myeconfargs=( $(use_with libvirt)
		$(use_with xen) )
	pushd src/${EGO_PN} || die
	econf "${myeconfargs[@]}"
	popd
}

src_compile() {
	GOPATH="${S}:$(get_golibdir_gopath)" emake -C src/${EGO_PN}
}

src_install() {
	dodoc src/${EGO_PN}/README.md
	dobin src/${EGO_PN}/hyperd
	dobin src/${EGO_PN}/hyperctl
	insinto /etc/hyper/
	doins src/${EGO_PN}/package/dist/etc/hyper/config
	systemd_dounit src/${EGO_PN}/package/dist/lib/systemd/system/hyperd.service
}
