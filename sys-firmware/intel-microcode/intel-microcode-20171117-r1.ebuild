# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs mount-boot

# Find updates by searching and clicking the first link (hopefully it's the one):
# http://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File

NUM="27337"
DESCRIPTION="Intel IA32/IA64 microcode update data"
HOMEPAGE="http://inertiawar.com/microcode/ https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=${NUM}"
SRC_URI="http://downloadmirror.intel.com/${NUM}/eng/microcode-${PV}.tgz"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="initramfs +split-ucode"
REQUIRED_USE="|| ( initramfs split-ucode )"

DEPEND="sys-apps/iucode_tool"
RDEPEND="!<sys-apps/microcode-ctl-1.17-r2" #268586

S=${WORKDIR}

# TODO: 
# Blacklist bad microcode here.
DEFAULT_MICROCODE_SIGNATURES=""

# Advanced users only:
# merge with:
# only current CPU: MICROCODE_SIGNATURES="-S"
# only specific CPU: MICROCODE_SIGNATURES="-s 0x00000f4a -s 0x00010676"
# exclude specific CPU: MICROCODE_SIGNATURES="-s !0x00000686"
MICROCODE_SIGNATURES="${MICROCODE_SIGNATURES:=${DEFAULT_MICROCODE_SIGNATURES}}"

pkg_pretend() {
	if [[ "${MICROCODE_SIGNATURES}" != "${DEFAULT_MICROCODE_SIGNATURES}" ]]; then
		ewarn "MICROCODE_SIGNATURES is set!"
		ewarn "The user has decided to install only a SUBSET of microcode."
	fi
	use initramfs && mount-boot_pkg_pretend
}

src_install() {
	# This will take ALL of the upstream microcode sources:
	# - microcode.dat
	# - intel-ucode/
	# In some cases, they have not contained the same content (eg the directory has newer stuff).
	MICROCODE_SRC=(
		"${S}"/microcode.dat
		"${S}"/intel-ucode/
	)
	opts=(
		${MICROCODE_SIGNATURES}
		# be strict about what we are doing
		--overwrite
		--strict-checks
		--no-ignore-broken
		# show everything we find
		--list-all
		# show what we selected
		--list
	)

	# The earlyfw cpio needs to be in /boot because it must be loaded before
	# rootfs is mounted.
	use initramfs && dodir /boot && opts+=( --write-earlyfw="${ED%/}"/boot/intel-uc.img )
	# split location:
	use split-ucode && dodir /lib/firmware/intel-ucode && opts+=( --write-firmware="${ED%/}"/lib/firmware/intel-ucode )

	iucode_tool \
		"${opts[@]}" \
		"${MICROCODE_SRC[@]}" \
		|| die "iucode_tool ${opts[@]} ${MICROCODE_SRC[@]}"

	dodoc releasenote
}

pkg_preinst() {
	use initramfs && mount-boot_pkg_preinst
}

pkg_prerm() {
	use initramfs && mount-boot_pkg_prerm
}

pkg_postrm() {
	use initramfs && mount-boot_pkg_postrm
}

pkg_postinst() {
	use initramfs && mount-boot_pkg_postinst
}
