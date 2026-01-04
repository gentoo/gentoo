# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver optfeature secureboot toolchain-funcs

DESCRIPTION="The UEFI Boot Manager by Rod Smith"
HOMEPAGE="https://www.rodsbooks.com/refind/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PV}/${PN}-src-${PV}.tar.gz"

LICENSE="BSD CC-BY-SA-3.0 CC-BY-SA-4.0 FDL-1.3 GPL-2+ GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
FS_USE="btrfs +ext2 +ext4 hfs +iso9660 ntfs reiserfs"
IUSE="${FS_USE} doc"

DEPEND="<sys-boot/gnu-efi-4.0.0"

# for ld.bfd and objcopy
BDEPEND="sys-devel/binutils"

DOCS=( README.txt NEWS.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-0.14.0.2-clang.patch
	"${FILESDIR}"/${P}-fix-gnu-efi-3.0.18.patch
	"${FILESDIR}"/${P}-fix-freestanding-on-musl.patch
	"${FILESDIR}"/${P}-fix-btrfs-on-musl.patch
	"${FILESDIR}"/${P}-fix-shim-name.patch
)

checktools() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		# bug #832018
		tc-export LD
		tc-ld-force-bfd
		# the makefile calls LD directly, so try to fix LD too
		LD="${LD/.lld/.bfd}"
		tc-ld-is-lld "${LD}" && die "Linking with lld produces broken executables and may lead to unbootable system"

		# bug #732256
		# llvm-objcopy does not support EFI target, try to use binutils objcopy or fail
		tc-export OBJCOPY
		OBJCOPY="${OBJCOPY/llvm-/}"
		LC_ALL=C "${OBJCOPY}" --help | grep -q '\<pei-' || die "${OBJCOPY} (objcopy) does not support EFI target"

		tc-is-gcc || tc-is-clang || die "Unsupported compiler"
	fi
}

pkg_setup() {
	if use x86; then
		export EFIARCH=ia32
		export BUILDARCH=ia32
	elif use amd64; then
		export EFIARCH=x64
		export BUILDARCH=x86_64
	fi
	secureboot_pkg_setup

	# this does not only check, but also exports LD and OBJCOPY
	checktools
}

src_prepare() {
	default

	# bug #598647 - PIE not supported
	sed -e '/^CFLAGS/s/$/ -fno-PIE/' -i Make.common || die
	sed -e '1 i\.NOTPARALLEL:' -i filesystems/Makefile || die

	cp "${FILESDIR}"/refind-sbat-gentoo-${PV}.csv refind-sbat-gentoo.csv || die
}

src_compile() {
	# Update fs targets depending on uses
	local fs fs_names=()
	for fs in ${FS_USE}; do
		fs=${fs#+}
		if use "${fs}"; then
			fs_names+=( ${fs} )
		fi
	done
	fs_names=( "${fs_names[@]/%/_gnuefi}" )

	# Prepare flags
	local make_flags=(
		ARCH="${BUILDARCH}"
		CC="$(tc-getCC)"
		AS="$(tc-getAS)"
		LD="${LD}"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		OBJCOPY="${OBJCOPY}"
		GNUEFILIB="${ESYSROOT}/usr/$(get_libdir)"
		EFILIB="${ESYSROOT}/usr/$(get_libdir)"
		EFICRT0="${ESYSROOT}/usr/$(get_libdir)"
		FILESYSTEMS="${fs_names[*]}"
		FILESYSTEMS_GNUEFI="${fs_names[*]}"
		REFIND_SBAT_CSV=refind-sbat-gentoo.csv
	)

	# see the comments in "${FILESDIR}"/${P}-fix-freestanding-on-musl.patch
	tc-export CC
	if tc-is-gcc; then
		local -x CPPINCLUDEDIR=$(LC_ALL=C ${CC} -print-search-dirs 2> /dev/null | grep ^install: | cut -f2 -d' ')/include
	elif tc-is-clang; then
		local -x CPPINCLUDEDIR=$(LC_ALL=C ${CC} -print-resource-dir 2> /dev/null)/include
		local -x EXTRACFLAGS=-D__DEFINED_wchar_t
	fi

	emake "${make_flags[@]}" all_gnuefi
}

src_install() {
	exeinto "/usr/$(get_libdir)/${PN}"
	doexe refind-install
	dosym -r "/usr/$(get_libdir)/${PN}/refind-install" "/usr/sbin/refind-install"

	doman "docs/man/"*
	use doc && DOCS+=( docs/refind docs/Styles )
	einstalldocs

	insinto "/usr/$(get_libdir)/${PN}/refind"
	doins "refind/refind_${EFIARCH}.efi"
	doins "refind.conf-sample"
	doins -r images icons fonts banners

	if [[ -d "drivers_${EFIARCH}" ]]; then
		doins -r "drivers_${EFIARCH}"
	fi

	insinto "/usr/$(get_libdir)/${PN}/refind/tools_${EFIARCH}"
	doins "gptsync/gptsync_${EFIARCH}.efi"

	insinto "/etc/refind.d"
	doins -r "keys"

	dosbin "mkrlconf"
	dosbin "mvrefind"
	dosbin "refind-mkdefault"

	secureboot_auto_sign --in-place
}

pkg_postinst() {
	elog "rEFInd has been built and installed into ${EROOT}/usr/$(get_libdir)/${PN}"
	elog "You will need to use the command 'refind-install' to install"
	elog "the binaries into your EFI System Partition"

	optfeature_header "refind-install requires additional packages to be fully functional:"
	optfeature "binary signing for use with SecureBoot" app-crypt/sbsigntools
	optfeature "writing to NVRAM" sys-boot/efibootmgr
	optfeature "ESP management" sys-apps/gptfdisk
	elog ""

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "A sample configuration can be found at"
		elog "${EROOT}/usr/$(get_libdir)/${PN}/refind/refind.conf-sample"
	else
		if ver_replacing -lt "0.12.0"; then
			ewarn "This new version uses sys-apps/gptfdisk instead of sys-block/parted"
			ewarn "to manage ESP"
			ewarn ""
		fi
		ewarn "Note that this installation will not update any EFI binaries"
		ewarn "on your EFI System Partition - this needs to be done manually"
	fi
}
