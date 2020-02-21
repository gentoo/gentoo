# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="SYSLINUX, PXELINUX, ISOLINUX, EXTLINUX and MEMDISK bootloaders"
HOMEPAGE="https://www.syslinux.org/"
SRC_URI="https://www.kernel.org/pub/linux/utils/boot/syslinux/${PV:0:1}.xx/${P/_/-}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="custom-cflags"

RDEPEND="sys-fs/mtools
		dev-perl/Crypt-PasswdMD5
		dev-perl/Digest-SHA1"
DEPEND="${RDEPEND}
	dev-lang/nasm
	virtual/os-headers"

S=${WORKDIR}/${P/_/-}

# This ebuild is a departure from the old way of rebuilding everything in syslinux
# This departure is necessary since hpa doesn't support the rebuilding of anything other
# than the installers.

# These are executables which come precompiled and are run by the boot loader
QA_PREBUILT="usr/share/${PN}/*.c32"

# removed all the unpack/patching stuff since we aren't rebuilding the core stuff anymore

src_prepare() {
	# Fix building on hardened
	epatch "${FILESDIR}"/${PN}-4.05-nopie.patch

	rm -f gethostip #bug 137081

	# Don't prestrip or override user LDFLAGS, bug #305783
	local SYSLINUX_MAKEFILES="extlinux/Makefile linux/Makefile mtools/Makefile \
		sample/Makefile utils/Makefile"
	sed -i ${SYSLINUX_MAKEFILES} -e '/^LDFLAGS/d' || die "sed failed"

	if use custom-cflags; then
		sed -i ${SYSLINUX_MAKEFILES} \
			-e 's|-g -Os||g' \
			-e 's|-Os||g' \
			-e 's|CFLAGS[[:space:]]\+=|CFLAGS +=|g' \
			|| die "sed custom-cflags failed"
	else
		QA_FLAGS_IGNORED="
			/sbin/extlinux
			/usr/bin/memdiskfind
			/usr/bin/gethostip
			/usr/bin/isohybrid
			/usr/bin/syslinux
			"
	fi

}

src_compile() {
	emake CC="$(tc-getCC)" installer
}

src_install() {
	emake INSTALLSUBDIRS=utils INSTALLROOT="${D}" MANDIR=/usr/share/man install
	dodoc README NEWS doc/*.txt
}

pkg_postinst() {
	# print warning for users upgrading from the previous stable version
	if has 4.07 ${REPLACING_VERSIONS}; then
		ewarn "syslinux now uses dynamically linked ELF executables. Before you reboot,"
		ewarn "ensure that needed dependencies are fulfilled. For example, run from your"
		ewarn "syslinux directory:"
		ewarn
		ewarn "LD_LIBRARY_PATH=\".\" ldd menu.c32"
	fi
}
