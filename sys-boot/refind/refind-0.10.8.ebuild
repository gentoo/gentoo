# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic versionator

DESCRIPTION="The UEFI Boot Manager by Rod Smith"
HOMEPAGE="https://www.rodsbooks.com/refind/"

SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${PN}-src-${PV}.tar.gz"

LICENSE="BSD GPL-2 GPL-3 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
FS_USE="btrfs +ext2 +ext4 hfs +iso9660 ntfs reiserfs"
IUSE="${FS_USE} -gnuefi doc -custom-cflags"

DEPEND="gnuefi? ( >=sys-boot/gnu-efi-3.0.2 )
	!gnuefi? ( >=sys-boot/udk-2015 )"

DOCS="NEWS.txt README.txt docs/refind docs/Styles"

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
	if use x86 ; then
		export EFIARCH=ia32
		export BUILDARCH=ia32
	elif use amd64; then
		export EFIARCH=x64
		export BUILDARCH=x86_64
	else
		# Try to support anyway
		export BUILDARCH=$( uname -m | sed s,i[3456789]86,ia32, )
		if [[ ${BUILDARCH} == "x86_64" ]] ; then
			export EFIARCH=x64
		else
			export EFIARCH=${ARCH}
		fi
	fi
}

src_prepare() {
	default

	# bug 598647 - PIE not supported
	sed -e 's:CFLAGS          =:& -fno-PIE:' -i "${S}/Make.common" || die

	local f
	for f in "${S}"/*/Make.tiano "${S}"/Make.common; do
		sed -i -e 's/^\(include .*target.txt.*\)$/#\1/' \
			-e 's@^\(TIANO_INCLUDE_DIRS\s*=\s*-I\s*\).*$@\1/usr/include/udk \\@' \
			-e '/^\s*-I \$(EDK2BASE).*$/d' \
			"${f}" || die "Failed to patch Tianocore make file in" \
			$(basename $(dirname ${f}))
	done
	for f in "${S}"/*/Make.tiano; do
		sed -i -e 's@^\(EFILIB\s*=\s*\).*$@\1/usr/lib@' \
			-e 's@\$(EFILIB).*/\([^/]*\).lib@-l\1@' \
			-e 's/\(--start-group\s*\$(ALL_EFILIBS)\)/-L \$(EFILIB) \1/' \
			"${f}" || die "Failed to patch Tianocore make file in" \
			$(basename $(dirname ${f}))
	done
	sed -i -e '/Guids/i#include "AutoGen.h"\n' "${S}/filesystems/AutoGen.c" \
		|| die "Failed to patch AutoGen.c"
	for f in "${S}"/*/AutoGen.c; do
		cat >>"${f}" <<-EOF || die "Failed to patch AutoGen.c"

			#define _PCD_TOKEN_PcdFixedDebugPrintErrorLevel  11U
			#define _PCD_SIZE_PcdFixedDebugPrintErrorLevel 4
			#define _PCD_GET_MODE_SIZE_PcdFixedDebugPrintErrorLevel  _PCD_SIZE_PcdFixedDebugPrintErrorLevel
			#define _PCD_VALUE_PcdFixedDebugPrintErrorLevel  0xFFFFFFFFU
			GLOBAL_REMOVE_IF_UNREFERENCED const UINT32 _gPcd_FixedAtBuild_PcdFixedDebugPrintErrorLevel = _PCD_VALUE_PcdFixedDebugPrintErrorLevel;
			extern const  UINT32  _gPcd_FixedAtBuild_PcdFixedDebugPrintErrorLevel;
			#define _PCD_GET_MODE_32_PcdFixedDebugPrintErrorLevel  _gPcd_FixedAtBuild_PcdFixedDebugPrintErrorLevel
			//#define _PCD_SET_MODE_32_PcdFixedDebugPrintErrorLevel  ASSERT(FALSE)  // It is not allowed to set value for a FIXED_AT_BUILD PCD
		EOF
	done
}

src_compile() {
	# Prepare flags
	local pecoff_header_size
	[[ $EFIARCH == x64 ]] && pecoff_header_size='0x228' \
		|| pecoff_header_size='0x220'
	local make_flags=(
		ARCH="${BUILDARCH}"
		GENFW="/usr/bin/GenFw"
		CC="$(tc-getCC)"
		AS="$(tc-getAS)"
		LD="$(tc-getLD)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		OBJCOPY="$(tc-getOBJCOPY)"
		GNUEFI_LDFLAGS="-T \$(GNUEFI_LDSCRIPT) -shared -nostdlib -Bsymbolic \
			-L\$(EFILIB) -L\$(GNUEFILIB) \$(CRTOBJS) -znocombreloc -zdefs"
		TIANO_LDSCRIPT="/usr/lib/GccBase.lds"
		TIANO_LDFLAGS="-n -q --gc-sections -nostdlib \
			--script=\$(TIANO_LDSCRIPT) \
			--defsym=PECOFF_HEADER_SIZE=${pecoff_header_size} \
			--entry \$(ENTRYPOINT) -u \$(ENTRYPOINT) -m \$(LD_CODE)"
	)

	# Make main EFI
	local all_target
	use gnuefi && all_target="gnuefi" || all_target="tiano"

	if use custom-cflags; then
		emake CFLAGS="${CFLAGS}" "${make_flags[@]}" ${all_target}
	else
		emake "${make_flags[@]}" ${all_target}
	fi

	# Make filesystem drivers
	local gnuefi_target
	use gnuefi && gnuefi_target="_gnuefi"
	local fs
	for fs in ${FS_USE}; do
		fs=${fs#+}
		if use "${fs}"; then
			einfo "Building ${fs} filesystem driver"
			if use custom-cflags; then
				emake CFLAGS="${CFLAGS}" "${make_flags[@]}" -C "${S}/filesystems" ${fs}${gnuefi_target}
			else
				emake "${make_flags[@]}" -C "${S}/filesystems" ${fs}${gnuefi_target}
			fi
		fi
	done
}

src_install() {
	exeinto "/usr/share/${P}"
	doexe refind-install
	dosym "/usr/share/${P}/refind-install" "/usr/sbin/refind-install"

	dodoc "${S}"/{COPYING.txt,LICENSE.txt,CREDITS.txt}
	if use doc; then
		doman "${S}/docs/man/"*
		dodoc -r ${DOCS}
	fi

	insinto "/usr/share/${P}/refind"
	doins "${S}/refind/refind_${EFIARCH}.efi"
	doins "${S}/refind.conf-sample"
	doins -r images icons fonts banners

	if [[ -d "${S}/drivers_${EFIARCH}" ]]; then
		doins -r "${S}/drivers_${EFIARCH}"
	fi

	insinto "/usr/share/${P}/refind/tools_${EFIARCH}"
	doins "${S}/gptsync/gptsync_${EFIARCH}.efi"

	insinto "/etc/refind.d"
	doins -r "${S}/keys"

	dosbin "${S}/mkrlconf"
	dosbin "${S}/mvrefind"
	dosbin "${S}/refind-mkdefault"
}

pkg_postinst() {
	elog "rEFInd has been built and installed into ${EROOT%/}/usr/share/${P}"
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
		elog "${EROOT%}/usr/share/${P}/refind/refind.conf-sample"
	else
		if ! version_is_at_least "0.10.3" "${REPLACING_VERSIONS}"; then
			elog "The new refind-mkdefault script requires >=dev-lang/python-3"
			elog "to be installed"
			elog ""
		fi
		ewarn "Note that this installation will not update any EFI binaries"
		ewarn "on your EFI System Partition - this needs to be done manually"
	fi
}
