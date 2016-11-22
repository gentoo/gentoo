# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

PATCHES=( "${FILESDIR}/${PN}-11.0-gcc46.patch"
	"${FILESDIR}/${PN}-11.0-uefi-support.patch"
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

	mymakeopts="${mymakeopts} LOADER_NO_GELI_SUPPORT=yes"
	export MAKEOBJDIRPREFIX="${WORKDIR}/build"
}

src_compile() {
	strip-flags
	append-flags "-fno-strict-aliasing"

	cd "${WORKDIR}/lib/libstand" || die
	freebsd_src_compile

	CFLAGS="${CFLAGS} -I${WORKDIR}/lib/libstand"
	LDFLAGS="${LDFLAGS} -L${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libstand"
	export LIBSTAND="${MAKEOBJDIRPREFIX}/${WORKDIR}/lib/libstand/libstand.a"

	cd "${S}" || die
	NOFLAGSTRIP="yes" freebsd_src_compile
}

src_install() {
	dodir /boot/defaults
	freebsd_src_install FILESDIR=/boot

	cd "${WORKDIR}/sys/$(tc-arch-kernel)/conf" || die
	insinto /boot
	newins GENERIC.hints device.hints

	echo 'CONFIG_PROTECT="/boot/device.hints"' > "${T}"/50boot0
	doenvd "${T}"/50boot0
}
