# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit linux-info toolchain-funcs mount-boot

# Find updates by searching and clicking the first link (hopefully it's the one):
# http://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File

COLLECTION_SNAPSHOT="20180426"
INTEL_SNAPSHOT="20180425"
NUM="27776"
DESCRIPTION="Intel IA32/IA64 microcode update data"
HOMEPAGE="http://inertiawar.com/microcode/ https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=${NUM}"
SRC_URI="https://downloadmirror.intel.com/${NUM}/eng/microcode-${INTEL_SNAPSHOT}.tgz
	https://dev.gentoo.org/~whissi/dist/intel-microcode/intel-microcode-collection-${COLLECTION_SNAPSHOT}.tar.xz"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS=""
IUSE="initramfs +split-ucode vanilla"
REQUIRED_USE="|| ( initramfs split-ucode )"

DEPEND="sys-apps/iucode_tool"
RDEPEND="!<sys-apps/microcode-ctl-1.17-r2" #268586

S=${WORKDIR}

# Blacklist bad microcode here.
# 0x000604f1 aka 06-4f-01 aka CPUID 406F1 require newer microcode loader
DEFAULT_MICROCODE_SIGNATURES="-s !0x000604f1"

# Advanced users only:
# merge with:
# only current CPU: MICROCODE_SIGNATURES="-S"
# only specific CPU: MICROCODE_SIGNATURES="-s 0x00000f4a -s 0x00010676"
# exclude specific CPU: MICROCODE_SIGNATURES="-s !0x00000686"
MICROCODE_SIGNATURES="${MICROCODE_SIGNATURES:=${DEFAULT_MICROCODE_SIGNATURES}}"

pkg_pretend() {
	if [[ "${MICROCODE_SIGNATURES}" != "${DEFAULT_MICROCODE_SIGNATURES}" ]]; then
		ewarn "The user has opted in for advanced use:"
		ewarn "MICROCODE_SIGNATURES is set to \"${MICROCODE_SIGNATURES}\" instead of default \"${DEFAULT_MICROCODE_SIGNATURES}\"!"
	fi
	use initramfs && mount-boot_pkg_pretend
}

src_prepare() {
	default

	# Prevent "invalid file format" errors from iucode_tool
	rm -f "${S}"/intel-ucod*/list || die
}

src_install() {
	# This will take ALL of the upstream microcode sources:
	# - microcode.dat
	# - intel-ucode/
	# In some cases, they have not contained the same content (eg the directory has newer stuff).
	MICROCODE_SRC=(
		"${S}"/intel-ucode/
		"${S}"/intel-ucode-with-caveats/
	)

	# Allow users who are scared about microcode updates not included in Intel's official
	# microcode tarball to opt-out and comply with Intel marketing
	if ! use vanilla; then
		MICROCODE_SRC+=( "${S}"/intel-microcode-collection-${COLLECTION_SNAPSHOT} )
	fi

	opts=(
		${MICROCODE_SIGNATURES}
		# be strict about what we are doing
		--overwrite
		--strict-checks
		--no-ignore-broken
		# we want to install latest version
		--no-downgrade
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

	if [[ "${MICROCODE_SIGNATURES}" != "${DEFAULT_MICROCODE_SIGNATURES}" ]]; then
		if kernel_is -lt 4 14 34; then
			ewarn "${P} contains microcode updates which require"
			ewarn "additional kernel patches which aren't yet included in kernel <4.14.34."
			ewarn "Loading such a microcode through kernel interface from an unpatched kernel"
			ewarn "can crash your system!"
			ewarn ""
			ewarn "Those microcodes are blacklisted per default. However, you have altered"
			ewarn "MICROCODE_SIGNATURES and maybe unintentionally re-enabled those microcodes."
			ewarn ""
			ewarn "Check ${EROOT%/}/usr/share/doc/${P}/releasenot* if your microcode update"
			ewarn "requires additional kernel patches or not."
		fi
	fi
}
