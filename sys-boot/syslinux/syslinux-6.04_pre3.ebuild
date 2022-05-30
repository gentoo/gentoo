# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="SYSLINUX, PXELINUX, ISOLINUX, EXTLINUX and MEMDISK bootloaders"
HOMEPAGE="https://www.syslinux.org/"
MY_P=${P/_/-}
SRC_URI="https://git.zytor.com/syslinux/syslinux.git/snapshot/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+bios efi32 efi64"
REQUIRED_USE="|| ( bios efi32 efi64 )"

BDEPEND="
	dev-lang/perl
	bios? (
		app-arch/upx
		app-text/asciidoc
		dev-lang/nasm
	)
"
RDEPEND="
	sys-apps/util-linux
	sys-fs/mtools
	dev-perl/Crypt-PasswdMD5
	dev-perl/Digest-SHA1
"
DEPEND="${RDEPEND}
	efi32? ( sys-boot/gnu-efi[abi_x86_32(-)] )
	efi64? ( sys-boot/gnu-efi[abi_x86_64(-)] )
	virtual/os-headers
"

S=${WORKDIR}/${MY_P}

QA_EXECSTACK="usr/share/syslinux/*"
QA_WX_LOAD="usr/share/syslinux/*"
QA_PRESTRIPPED="usr/share/syslinux/.*"
QA_FLAGS_IGNORED=".*"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PV}"
	)
	default
}

efimake() {
	local ABI="${1}"
	local libdir="$(get_libdir)"
	shift
	local args=(
		EFIINC="${ESYSROOT}/usr/include/efi"
		LIBDIR="${ESYSROOT}/usr/${libdir}"
		LIBEFI="${ESYSROOT}/usr/${libdir}/libefi.a"
		"${@}"
	)
	emake "${args[@]}"
}

src_compile() {
	tc-export AR CC LD OBJCOPY RANLIB
	unset LDFLAGS
	if use bios; then
		emake bios
	fi
	if use efi32; then
		efimake x86 efi32
	fi
	if use efi64; then
		efimake amd64 efi64
	fi
}

src_install() {
	local args=(
		INSTALLROOT="${ED}"
		MANDIR='$(DATADIR)/man'
		$(usev bios)
		$(usev efi32)
		$(usev efi64)
		install
	)
	emake -j1 "${args[@]}"
	einstalldocs
	dostrip -x /usr/share/syslinux
}
