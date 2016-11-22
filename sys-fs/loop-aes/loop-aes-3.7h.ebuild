# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils linux-mod

MY_P="${PN/aes/AES}-v${PV}"

DESCRIPTION="Linux kernel module to encrypt disk partitions with AES cipher"
HOMEPAGE="http://loop-aes.sourceforge.net/loop-AES.README"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~sparc x86"
IUSE="cpu_flags_x86_aes extra-ciphers keyscrub cpu_flags_x86_padlock"

DEPEND="app-crypt/loop-aes-losetup"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	linux-mod_pkg_setup

	CONFIG_CHECK="!BLK_DEV_LOOP"
	MODULE_NAMES="loop(block::tmp-d-kbuild)"
	BUILD_TARGETS="all"

	BUILD_PARAMS=" \
		V=1 \
		LINUX_SOURCE=\"${KERNEL_DIR}\" \
		KBUILD_OUTPUT=\"${KBUILD_OUTPUT}\" \
		USE_KBUILD=y MODINST=n RUNDM=n"
	use cpu_flags_x86_aes && BUILD_PARAMS="${BUILD_PARAMS} INTELAES=y"
	use keyscrub && BUILD_PARAMS="${BUILD_PARAMS} KEYSCRUB=y"
	use cpu_flags_x86_padlock && BUILD_PARAMS="${BUILD_PARAMS} PADLOCK=y"

	if use extra-ciphers; then
		MODULE_NAMES="${MODULE_NAMES}
			loop_blowfish(block::tmp-d-kbuild)
			loop_serpent(block::tmp-d-kbuild)
			loop_twofish(block::tmp-d-kbuild)"
		BUILD_PARAMS="${BUILD_PARAMS} EXTRA_CIPHERS=y"
	fi
}

src_install() {
	linux-mod_src_install

	dodoc README
	dobin loop-aes-keygen
	doman loop-aes-keygen.1
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo
	einfo "For more instructions take a look at examples in README at:"
	einfo "'${EPREFIX}/usr/share/doc/${PF}'"
	einfo
	einfo "If you have a newer Intel processor (i5, i7), and you use AES"
	einfo "you may want to consider using the aes-ni use flag. It will"
	einfo "use your processors native AES instructions giving quite a speed"
	einfo "increase."
	einfo

	ewarn
	ewarn "Please consider using loop-aes-losetup package instead of"
	ewarn "util-linux[loop-aes], it will enable all loop-aes services"
	ewarn "without patching util-linux package"
	ewarn
	ewarn "In future only loop-aes-losetup will be available in portage"
	ewarn
}
