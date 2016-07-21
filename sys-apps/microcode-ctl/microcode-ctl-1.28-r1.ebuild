# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

MY_P=${PN/-/_}-${PV}
DESCRIPTION="Intel processor microcode update utility"
HOMEPAGE="https://fedorahosted.org/microcode_ctl/"
SRC_URI="https://fedorahosted.org/released/${PN/-/_}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="selinux"

DEPEND=""
RDEPEND=">=sys-firmware/intel-microcode-20090330
	selinux? ( sec-policy/selinux-cpucontrol )"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS} ${LDFLAGS}"
}

src_install() {
	dosbin microcode_ctl
	doman microcode_ctl.8
	dodoc Changelog README
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-1.28-r1" ; then
		elog "The init scripts have been removed as they are unsafe.  If you want to update"
		elog "the microcode in your system, please use an initramfs.  See bug #528712#41 for"
		elog "details (and bug #557278 for genkernel users)."
	fi
}
