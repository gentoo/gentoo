# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="1"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="Full XanMod sources with the Gentoo patchset "
HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64"
XANMOD_VERSION="1"
XANMOD_URI="https://github.com/xanmod/linux/releases/download/"
SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	${XANMOD_URI}/${OKV}-xanmod${XANMOD_VERSION}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz
	${GENPATCHES_URI}
"

src_unpack() {
UNIPATCH_LIST_DEFAULT=""
		UNIPATCH_LIST="${DISTDIR}/patch-${OKV}-xanmod${XANMOD_VERSION}.xz "
	kernel-2_src_unpack
}

src_prepare() {

	kernel-2_src_prepare

}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use xanmod-sources with microcodes"
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"
}
