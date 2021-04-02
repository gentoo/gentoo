# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="SYSLINUX, PXELINUX, ISOLINUX, EXTLINUX and MEMDISK bootloaders"
HOMEPAGE="https://www.syslinux.org/"
# Final releases in 6.xx/${PV}.tar.* (literal "xx")
# Testing releases in Testing/${PV}/${PV}.tar.*
SRC_URI_DIR=${PV:0:1}.xx
SRC_URI_TESTING=Testing/${PV:0:4}
[[ ${PV/_alpha} != ${PV} ]] && SRC_URI_DIR=${SRC_URI_TESTING}
[[ ${PV/_beta} != ${PV} ]] && SRC_URI_DIR=${SRC_URI_TESTING}
[[ ${PV/_pre} != ${PV} ]] && SRC_URI_DIR=${SRC_URI_TESTING}
[[ ${PV/_rc} != ${PV} ]] && SRC_URI_DIR=${SRC_URI_TESTING}
SRC_URI="https://www.kernel.org/pub/linux/utils/boot/syslinux/${SRC_URI_DIR}/${P/_/-}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
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

PATCHES=(
	"${FILESDIR}"/${PN}-6.03-sysmacros.patch #579928
	"${FILESDIR}"/${P}-singleloadsegment.patch #662678
	"${FILESDIR}"/${P}-fcommon.patch #705730
)

src_prepare() {
	default

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

	# building with ld.gold causes problems, bug #563364
	if tc-ld-is-gold; then
		ewarn "Building syslinux with the gold linker may cause problems, see bug #563364"
		if [[ -z "${I_KNOW_WHAT_I_AM_DOING}" ]]; then
			tc-ld-disable-gold
			ewarn "set I_KNOW_WHAT_I_AM_DOING=1 to override this."
		else
			ewarn "Continuing anyway as requested."
		fi
	fi

	tc-export AR CC LD OBJCOPY RANLIB
}

_emake() {
	emake \
		AR="${AR}" \
		CC="${CC}" \
		LD="${LD}" \
		OBJCOPY="${OBJCOPY}" \
		RANLIB="${RANLIB}" \
		"$@"
}

src_compile() {
	# build system abuses the LDFLAGS variable to pass arguments to ld
	unset LDFLAGS
	if [[ ! -z ${loaderarch} ]]; then
		_emake ${loaderarch}
	fi
	_emake ${loaderarch} installer
}

src_install() {
	# parallel install fails sometimes
	einfo "loaderarch=${loaderarch}"
	_emake -j1 INSTALLROOT="${D}" MANDIR=/usr/share/man bios ${loaderarch} install
	dodoc README NEWS doc/*.txt
}
