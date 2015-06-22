# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/aufs-sources/aufs-sources-3.18.16.ebuild,v 1.1 2015/06/22 08:09:48 jlec Exp $

EAPI=5

ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="17"
K_DEBLOB_AVAILABLE="1"
UNIPATCH_STRICTORDER=1
inherit kernel-2 eutils readme.gentoo
detect_version
detect_arch

AUFS_VERSION=3.18.1+_p20150622
AUFS_TARBALL="aufs-sources-${AUFS_VERSION}.tar.xz"
# git archive -v --remote=git://git.code.sf.net/p/aufs/aufs3-standalone aufs${AUFS_VERSION/_p*} > aufs-sources-${AUFS_VERSION}.tar
AUFS_URI="http://dev.gentoo.org/~jlec/distfiles/${AUFS_TARBALL}"

KEYWORDS="~amd64 ~x86"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches http://aufs.sourceforge.net/"
IUSE="deblob experimental module vanilla"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree and aufs3 support"
SRC_URI="
	${KERNEL_URI}
	${ARCH_URI}
	${AUFS_URI}
	!vanilla? ( ${GENPATCHES_URI} )
	"

PDEPEND="=sys-fs/aufs-util-3*"

README_GENTOO_SUFFIX="-r1"

src_unpack() {
	if use vanilla; then
		unset UNIPATCH_LIST_GENPATCHES UNIPATCH_LIST_DEFAULT
		ewarn "You are using USE=vanilla"
		ewarn "This will drop all support from the gentoo kernel security team"
	fi

	UNIPATCH_LIST="
		"${WORKDIR}"/aufs3-kbuild.patch
		"${WORKDIR}"/aufs3-base.patch
		"${WORKDIR}"/aufs3-mmap.patch"

	use module && UNIPATCH_LIST+=" "${WORKDIR}"/aufs3-standalone.patch"

	unpack ${AUFS_TARBALL}

	einfo "Using aufs3 version: ${AUFS_VERSION}"

	kernel-2_src_unpack
}

src_prepare() {
	if ! use module; then
		sed -e 's:tristate:bool:g' -i "${WORKDIR}"/fs/aufs/Kconfig || die
	fi
	cp -f "${WORKDIR}"/include/uapi/linux/aufs_type.h include/uapi/linux/aufs_type.h || die
	cp -rf "${WORKDIR}"/{Documentation,fs} . || die
}

src_install() {
	kernel-2_src_install
	dodoc "${WORKDIR}"/{aufs3-loopback,vfs-ino,tmpfs-idr}.patch
	docompress -x /usr/share/doc/${PF}/{aufs3-loopback,vfs-ino,tmpfs-idr}.patch
	readme.gentoo_create_doc
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
	has_version sys-fs/aufs-util || \
		elog "In order to use aufs FS you need to install sys-fs/aufs-util"

	readme.gentoo_pkg_postinst
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
