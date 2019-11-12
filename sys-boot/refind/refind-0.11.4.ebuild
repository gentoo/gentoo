# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing toolchain-funcs

DESCRIPTION="The UEFI Boot Manager by Rod Smith"
HOMEPAGE="https://www.rodsbooks.com/refind/"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${PN}-src-${PV}.tar.gz"

LICENSE="BSD GPL-2 GPL-3 FDL-1.3"
SLOT="0"
KEYWORDS="amd64 x86"
FS_USE="btrfs +ext2 +ext4 hfs +iso9660 ntfs reiserfs"
IUSE="${FS_USE} custom-cflags doc gnuefi"

DEPEND="gnuefi? ( >=sys-boot/gnu-efi-3.0.2 )
	!gnuefi? ( >=sys-boot/udk-2018-r1 )"

DOCS=(README.txt)
PATCHES=("${FILESDIR}/makefile.patch")
UDK_WORKSPACE="${T}/udk"

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
	sed -e '/^CFLAGS/s:$: -fno-PIE:' -i Make.common || die

	# Prepare UDK workspace
	if ! use gnuefi; then
		mkdir "${UDK_WORKSPACE}" || die
		ln -s "${EPREFIX}/usr/lib/udk/"{Mde,IntelFramework}{,Module}Pkg \
			"${UDK_WORKSPACE}" || die "Could not link UDK files"
	fi
}

src_configure() {
	if ! use gnuefi; then
		# Use the side effect of the script which will create configuration files
		(. udk-workspace "${UDK_WORKSPACE}" || die)
		sed -e "s:^#\?\s*\(MAX_CONCURRENT_THREAD_NUMBER\s*=\).*$:\1 $(makeopts_jobs):" \
			-i "${UDK_WORKSPACE}/Conf/target.txt" || die "Failed to configure target file"
		sed -e "s:\(_\(CC\|ASM\|PP\|VFRPP\|ASLCC\|ASLPP\|DLINK\)_PATH\s*=\).*$:\1 $(tc-getCC):" \
			-e "s:\(_ASLDLINK_PATH\s*=\).*$:\1 $(tc-getLD):" \
			-e "s:\(_OBJCOPY_PATH\s*=\).*$:\1 $(tc-getOBJCOPY):" \
			-e "s:\(_RC_PATH\s*=\).*$:\1 $(tc-getOBJCOPY):" \
			-e "s:\(_SLINK_PATH\s*=\).*$:\1 $(tc-getAR):" \
			-e "s:-Werror::" \
			-i "${UDK_WORKSPACE}/Conf/tools_def.txt" \
			|| die "Failed to prepare tools definition file"
	fi
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
	use gnuefi && fs_names=("${fs_names[@]/%/_gnuefi}")

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
		EDK2BASE="${UDK_WORKSPACE}"
		EDK2_DRIVER_BASENAMES="${fs_names[@]}"
		FILESYSTEMS="${fs_names[@]}"
		FILESYSTEMS_GNUEFI="${fs_names[@]}"
	)
	if use custom-cflags; then
		make_flags=(CFLAGS="${CFLAGS}" "${make_flags[@]}")
	fi

	emake "${make_flags[@]}" all_$(usex gnuefi gnuefi edk2)
}

src_install() {
	exeinto "/usr/lib/${PN}"
	doexe refind-install
	dosym "../lib/${PN}/refind-install" "/usr/sbin/refind-install"

	if use doc; then
		doman "docs/man/"*
		DOCS+=(NEWS.txt docs/refind docs/Styles)
	fi
	einstalldocs

	insinto "/usr/lib/${PN}/refind"
	doins "refind/refind_${EFIARCH}.efi"
	doins "refind.conf-sample"
	doins -r images icons fonts banners

	if [[ -d "drivers_${EFIARCH}" ]]; then
		doins -r "drivers_${EFIARCH}"
	fi

	insinto "/usr/lib/${PN}/refind/tools_${EFIARCH}"
	doins "gptsync/gptsync_${EFIARCH}.efi"

	insinto "/etc/refind.d"
	doins -r "keys"

	dosbin "mkrlconf"
	dosbin "mvrefind"
	dosbin "refind-mkdefault"
}

pkg_postinst() {
	elog "rEFInd has been built and installed into ${EROOT}/usr/lib/${PN}"
	elog "You will need to use the command 'refind-install' to install"
	elog "the binaries into your EFI System Partition"
	elog ""
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "refind-install requires additional packages to be fully functional:"
		elog " app-crypt/sbsigntools for binary signing for use with SecureBoot"
		elog " sys-boot/efibootmgr for writing to NVRAM"
		elog " sys-block/parted for automatic ESP location and mount"
		elog ""
		elog "refind-mkdefault requires >=dev-lang/python-3"
		elog ""
		elog "A sample configuration can be found at"
		elog "${EROOT}/usr/lib/${PN}/refind/refind.conf-sample"
	else
		if ver_test "${REPLACING_VERSIONS}" -lt "0.10.3"; then
			elog "The new refind-mkdefault script requires >=dev-lang/python-3"
			elog "to be installed"
			elog ""
		fi
		ewarn "Note that this installation will not update any EFI binaries"
		ewarn "on your EFI System Partition - this needs to be done manually"
	fi
}
