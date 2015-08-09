# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ "${PV}" != "9999" ]]; then
	SRC_URI="http://dev.gentoo.org/~lxnay/genkernel-next/${P}.tar.xz"
else
	EGIT_REPO_URI="git://github.com/Sabayon/genkernel-next.git"
	inherit git-2
fi
inherit bash-completion-r1 eutils

if [[ "${PV}" == "9999" ]]; then
	KEYWORDS="ppc"
else
	KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~x86"
fi

DESCRIPTION="Gentoo automatic kernel building scripts, reloaded"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
RESTRICT=""
IUSE="cryptsetup dmraid gpg iscsi mdadm plymouth selinux"

DEPEND="app-text/asciidoc
	sys-fs/e2fsprogs
	!sys-fs/eudev[-kmod,modutils]
	selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND}
	!sys-kernel/genkernel
	cryptsetup? ( sys-fs/cryptsetup )
	dmraid? ( >=sys-fs/dmraid-1.0.0_rc16 )
	gpg? ( app-crypt/gnupg )
	iscsi? ( sys-block/open-iscsi )
	mdadm? ( sys-fs/mdadm )
	plymouth? ( sys-boot/plymouth[libkms] )
	app-portage/portage-utils
	app-arch/cpio
	>=app-misc/pax-utils-0.6
	!<sys-apps/openrc-0.9.9
	sys-apps/util-linux
	sys-block/thin-provisioning-tools
	sys-fs/lvm2"

src_prepare() {
	sed -i "/^GK_V=/ s:GK_V=.*:GK_V=${PV}:g" "${S}/genkernel" || \
		die "Could not setup release"

	epatch_user
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	doman "${S}"/genkernel.8 || die "doman"
	dodoc "${S}"/AUTHORS || die "dodoc"

	newbashcomp "${S}"/genkernel.bash genkernel
}
