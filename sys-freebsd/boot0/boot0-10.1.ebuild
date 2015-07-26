# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/boot0/boot0-10.1.ebuild,v 1.5 2015/07/25 12:09:21 mgorny Exp $

EAPI=5

inherit bsdmk freebsd flag-o-matic toolchain-funcs

DESCRIPTION="FreeBSD's bootloader"
SLOT="0"

IUSE="bzip2 ieee1394 tftp zfs"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

EXTRACTONLY="
	sys/
	lib/
	contrib/bzip2/
"

RDEPEND=""
DEPEND="=sys-freebsd/freebsd-mk-defs-${RV}*
	=sys-freebsd/freebsd-lib-${RV}*"

S="${WORKDIR}/sys/boot"

PATCHES=( "${FILESDIR}/${PN}-10.1-gcc46.patch"
	"${FILESDIR}/${PN}-10.1-drop-unsupport-cflags.patch"
	"${FILESDIR}/${PN}-add-nossp-cflags.patch" )

boot0_use_enable() {
	use ${1} && mymakeopts="${mymakeopts} LOADER_${2}_SUPPORT=\"yes\""
	use ${1} || mymakeopts="${mymakeopts} WITHOUT_${2}= "
}

pkg_setup() {
	boot0_use_enable ieee1394 FIREWIRE
	boot0_use_enable zfs ZFS
	boot0_use_enable tftp TFTP
	boot0_use_enable bzip2 BZIP2
}

src_prepare() {
	sed -e '/-mno-align-long-strings/d' \
		-i "${S}"/i386/boot2/Makefile \
		-i "${S}"/i386/gptboot/Makefile \
		-i "${S}"/i386/gptzfsboot/Makefile \
		-i "${S}"/i386/zfsboot/Makefile || die
}

src_compile() {
	strip-flags
	append-flags "-fno-strict-aliasing"

	if use amd64-fbsd; then
		cd "${S}/userboot/libstand" || die
		freebsd_src_compile
		cd "${S}/userboot/zfs" || die
		freebsd_src_compile
	fi

	cd "${S}/libstand32" || die
	freebsd_src_compile

	# bug542676
	if [[ $(tc-getCC) == *clang* ]]; then
		cd "${S}/i386/btx" || die
		freebsd_src_compile
		cd "${S}/i386/boot2" || die
		CC=${CHOST}-gcc freebsd_src_compile
	fi

	cd "${WORKDIR}/lib/libstand" || die
	freebsd_src_compile

	cd "${S}"
	CFLAGS="${CFLAGS} -I${WORKDIR}/lib/libstand"
	LDFLAGS="${LDFLAGS} -L${WORKDIR}/lib/libstand"
	export LIBSTAND="${WORKDIR}/lib/libstand/libstand.a"
	NOFLAGSTRIP="yes" freebsd_src_compile
}

src_install() {
	dodir /boot/defaults
	mkinstall FILESDIR=/boot || die "mkinstall failed"

	cd "${WORKDIR}/sys/$(tc-arch-kernel)/conf" || die
	insinto /boot
	newins GENERIC.hints device.hints

	echo 'CONFIG_PROTECT="/boot/device.hints"' > "${T}"/50boot0
	doenvd "${T}"/50boot0
}
