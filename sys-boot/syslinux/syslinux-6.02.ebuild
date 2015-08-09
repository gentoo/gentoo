# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="SYSLINUX, PXELINUX, ISOLINUX, EXTLINUX and MEMDISK bootloaders"
HOMEPAGE="http://www.syslinux.org/"
SRC_URI="mirror://kernel/linux/utils/boot/syslinux/${P/_/-}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="custom-cflags"

RDEPEND="sys-fs/mtools
		dev-perl/Crypt-PasswdMD5
		dev-perl/Digest-SHA1"
DEPEND="${RDEPEND}
	dev-lang/nasm
	>=sys-boot/gnu-efi-3.0u
	virtual/os-headers"

S=${WORKDIR}/${P/_/-}

# This ebuild is a departure from the old way of rebuilding everything in syslinux
# This departure is necessary since hpa doesn't support the rebuilding of anything other
# than the installers.

# These are executables which come precompiled and are run by the boot loader
QA_PREBUILT="usr/share/${PN}/*.c32"

# removed all the unpack/patching stuff since we aren't rebuilding the core stuff anymore

src_prepare() {
	epatch "${FILESDIR}"/${P}-add-fno-stack-protector.patch
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
	case ${ARCH} in
		amd64)	loaderarch="efi64" ;;
		x86)	loaderarch="efi32" ;;
		*)	ewarn "Unsupported architecture, building installers only." ;;
	esac
}

src_compile() {
	# build system abuses the LDFLAGS variable to pass arguments to ld
	unset LDFLAGS
	if [[ ! -z ${loaderarch} ]]; then
		emake CC=$(tc-getCC) LD=$(tc-getLD) ${loaderarch}
	fi
	emake CC=$(tc-getCC) LD=$(tc-getLD) ${loaderarch} installer
}

src_install() {
	# parallel install fails sometimes
	einfo "loaderarch=${loaderarch}"
	emake -j1 LD=$(tc-getLD) INSTALLROOT="${D}" MANDIR=/usr/share/man bios ${loaderarch} install
	dodoc README NEWS doc/*.txt
}

pkg_postinst() {
	# print warning for users upgrading from the previous stable version
	if has 4.06 ${REPLACING_VERSIONS}; then
		ewarn "syslinux now uses dynamically linked ELF executables. Before you reboot,"
		ewarn "ensure that needed dependencies are fulfilled. For example, run from your"
		ewarn "syslinux directory:"
		ewarn
		ewarn "LD_LIBRARY_PATH=\".\" ldd menu.c32"
	fi
}
