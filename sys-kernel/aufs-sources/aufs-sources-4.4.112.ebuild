# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER=116
UNIPATCH_STRICTORDER=1
inherit kernel-2 eutils readme.gentoo-r1

AUFS_VERSION=4.4_p20171127
AUFS_TARBALL="aufs-sources-${AUFS_VERSION}.tar.xz"
# git archive -v --remote=git://git.code.sf.net/p/aufs/aufs4-standalone aufs${AUFS_VERSION/_p*} > aufs-sources-${AUFS_VERSION}.tar
AUFS_URI="https://dev.gentoo.org/~jlec/distfiles/${AUFS_TARBALL}"

KEYWORDS="~amd64 ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches http://aufs.sourceforge.net/"
IUSE="experimental module vanilla"

DESCRIPTION="Full sources (incl. Gentoo patchset) for the linux kernel tree and aufs4 support"
SRC_URI="
	${KERNEL_URI}
	${ARCH_URI}
	${AUFS_URI}
	!vanilla? ( ${GENPATCHES_URI} )
	"

PDEPEND="=sys-fs/aufs-util-4*"

README_GENTOO_SUFFIX="-r1"

src_unpack() {
	detect_version
	detect_arch
	if use vanilla; then
		unset UNIPATCH_LIST_GENPATCHES UNIPATCH_LIST_DEFAULT
		ewarn "You are using USE=vanilla"
		ewarn "This will drop all support from the gentoo kernel security team"
	fi

	UNIPATCH_LIST="
		"${WORKDIR}"/aufs4-kbuild.patch
		"${WORKDIR}"/aufs4-base.patch
		"${WORKDIR}"/aufs4-mmap.patch"

	use module && UNIPATCH_LIST+=" "${WORKDIR}"/aufs4-standalone.patch"

	unpack ${AUFS_TARBALL}

	einfo "Using aufs4 version: ${AUFS_VERSION}"

	kernel-2_src_unpack
}

src_prepare() {
	kernel-2_src_prepare
	if ! use module; then
		sed -e 's:tristate:bool:g' -i "${WORKDIR}"/fs/aufs/Kconfig || die
	fi
	cp -f "${WORKDIR}"/include/uapi/linux/aufs_type.h include/uapi/linux/aufs_type.h || die
	cp -rf "${WORKDIR}"/{Documentation,fs} . || die
}

src_install() {
	kernel-2_src_install
	dodoc "${WORKDIR}"/{aufs4-loopback,vfs-ino,tmpfs-idr}.patch
	docompress -x /usr/share/doc/${PF}/{aufs4-loopback,vfs-ino,tmpfs-idr}.patch
	readme.gentoo_create_doc
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
	has_version sys-fs/aufs-util || \
		elog "In order to use aufs FS you need to install sys-fs/aufs-util"

	readme.gentoo_print_elog
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
