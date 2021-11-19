# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing toolchain-funcs

DESCRIPTION="The UEFI Boot Manager by Rod Smith"
HOMEPAGE="https://www.rodsbooks.com/refind/"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${PN}-src-${PV}.tar.gz"

LICENSE="BSD GPL-2 GPL-3 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
FS_USE="btrfs +ext2 +ext4 hfs +iso9660 ntfs reiserfs"
IUSE="${FS_USE} custom-cflags doc"

DEPEND="sys-boot/gnu-efi"

DOCS=( README.txt )

PATCHES=(
	"${FILESDIR}"/${P}-gnuefi-3.0.14.patch
)

pkg_pretend() {
	if use custom-cflags; then
		ewarn
		ewarn "You have enabled building with USE=custom-cflags. Be aware that"
		ewarn "using this can result in EFI binaries that fail to run and may"
		ewarn "fail to build at all. This is strongly advised against by upstream."
		ewarn
		ewarn "See https://bugs.gentoo.org/598587#c3 for more information"
		ewarn
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
}

src_prepare() {
	default

	# bug 598647 - PIE not supported
	sed -e '/^CFLAGS/s/$/ -fno-PIE/' -i Make.common || die
	sed -e '1 i\.NOTPARALLEL:' -i filesystems/Makefile || die
}

src_compile() {
	# Update fs targets depending on uses
	local fs fs_names=()
	for fs in ${FS_USE}; do
		fs=${fs#+}
		if use "${fs}"; then
			fs_names+=(${fs})
		fi
	done
	fs_names=("${fs_names[@]/%/_gnuefi}")

	# Prepare flags
	local make_flags=(
		ARCH="${BUILDARCH}"
		CC="$(tc-getCC)"
		AS="$(tc-getAS)"
		LD="$(tc-getLD)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		OBJCOPY="$(tc-getOBJCOPY)"
		GNUEFILIB="/usr/$(get_libdir)"
		EFILIB="/usr/$(get_libdir)"
		EFICRT0="/usr/$(get_libdir)"
		FILESYSTEMS="${fs_names[*]}"
		FILESYSTEMS_GNUEFI="${fs_names[*]}"
	)
	if use custom-cflags; then
		make_flags=(CFLAGS="${CFLAGS} -fno-tree-loop-distribute-patterns" "${make_flags[@]}")
	fi

	emake "${make_flags[@]}" all_gnuefi
}

src_install() {
	exeinto "/usr/$(get_libdir)/${PN}"
	doexe refind-install
	dosym "../$(get_libdir)/${PN}/refind-install" "/usr/sbin/refind-install"

	if use doc; then
		doman "docs/man/"*
		DOCS+=(NEWS.txt docs/refind docs/Styles)
	fi
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
}

pkg_postinst() {
	elog "rEFInd has been built and installed into ${EROOT}/usr/$(get_libdir)/${PN}"
	elog "You will need to use the command 'refind-install' to install"
	elog "the binaries into your EFI System Partition"
	elog ""
	elog "refind-install requires additional packages to be fully functional:"
	elog " app-crypt/sbsigntools for binary signing for use with SecureBoot"
	elog " sys-boot/efibootmgr for writing to NVRAM"
	elog " sys-apps/gptfdisk for ESP management"
	elog ""
	elog "refind-mkdefault requires >=dev-lang/python-3"
	elog ""
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "A sample configuration can be found at"
		elog "${EROOT}/usr/$(get_libdir)/${PN}/refind/refind.conf-sample"
	else
		if ver_test "${REPLACING_VERSIONS}" -lt "0.12.0"; then
			ewarn "This new version uses sys-apps/gptfdisk instead of sys-block/parted"
			ewarn "to manage ESP"
			ewarn ""
		fi
		ewarn "Note that this installation will not update any EFI binaries"
		ewarn "on your EFI System Partition - this needs to be done manually"
	fi
}
