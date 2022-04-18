# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ETYPE=sources
K_EXP_GENPATCHES_NOUSE=1
K_GENPATCHES_VER=2
K_DEFCONFIG="bcmrpi_defconfig"
K_GENPATCHES_VER=1
K_SECURITY_UNSUPPORTED=1
K_WANT_GENPATCHES="base extras"

inherit kernel-2 linux-info
detect_version
detect_arch

MY_P=$(ver_cut 4-)
MY_P="1.${MY_P/p/}"

DESCRIPTION="Raspberry Pi kernel sources"
HOMEPAGE="https://github.com/raspberrypi/linux"
SRC_URI="
	https://github.com/raspberrypi/linux/archive/${MY_P}.tar.gz -> linux-${KV_FULL}.tar.gz
	${GENPATCHES_URI}
"

KEYWORDS="~arm ~arm64"

PATCHES=("${FILESDIR}"/${PN}-$(ver_cut 1-3)-gentoo-kconfig.patch)

UNIPATCH_EXCLUDE="
	10*
	4567_distro-Gentoo-Kconfig.patch"

pkg_setup() {
	ewarn ""
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the raspberrypi developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	kernel-2_pkg_setup
}

src_unpack() {
	local OKV_ARRAY
	IFS="." read -r -a OKV_ARRAY <<<"${OKV}"

	cd "${WORKDIR}" || die
	unpack linux-${PV}-raspberrypi.tar.gz

	# We want to rename the unpacked directory to a nice normalised string
	# bug #762766
	mv linux-${MY_P} linux-${KV_FULL} || die "Unable to move source tree to ${KV_FULL}."

	# remove all backup files
	find . -iname "*~" -exec rm {} \; 2>/dev/null
}

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES().
	default

	cd "${WORKDIR}/linux-${KV_FULL}" || die

	handle_genpatches --set-unipatch-list
	[[ -n ${UNIPATCH_LIST} || -n ${UNIPATCH_LIST_DEFAULT} || -n ${UNIPATCH_LIST_GENPATCHES} ]] && \
		unipatch "${UNIPATCH_LIST_DEFAULT} ${UNIPATCH_LIST_GENPATCHES} ${UNIPATCH_LIST}"

	unpack_fix_install_path

	# Setup xmakeopts and cd into sourcetree.
	env_setup_xmakeopts
	cd "${S}" || die
}

pkg_postinst() {
	kernel-2_pkg_postinst
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
