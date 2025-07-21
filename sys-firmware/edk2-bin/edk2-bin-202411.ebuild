# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 secureboot

BINPKG="${P/-bin/}-1"
ARCHES="amd64 arm64 riscv"

DESCRIPTION="TianoCore EDK II UEFI firmware for virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"
SRC_URI=$(printf "https://dev.gentoo.org/~chewi/distfiles/${BINPKG}-%s.xpak\n" ${ARCHES})
S="${WORKDIR}"
LICENSE="BSD-2-with-patent MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc ppc64 ~riscv x86"

RDEPEND="!sys-firmware/edk2"

DOC_CONTENTS="This package includes the TianoCore EDK II UEFI firmware for virtual \
machines of these architectures: ${ARCHES}. See each architecture's README for \
usage details."

src_unpack() {
	local a
	for a in ${ARCHES}; do
		mkdir "${a}" || die
		tar -C "${a}" -xf - < <(xz -c -d --single-stream "${DISTDIR}/${BINPKG}-${a}.xpak") ||
			die "unpacking ${a} binpkg failed"
	done
}

src_prepare() {
	bunzip2 */usr/share/doc/*/README.gentoo.bz2 || die
	default
}

src_install() {
	insinto /usr/share
	doins -r */usr/share/{edk2,qemu}/

	# Compatibility with older package versions.
	dosym edk2/OvmfX64 /usr/share/edk2-ovmf

	secureboot_auto_sign --in-place
	readme.gentoo_create_doc

	local a
	for a in ${ARCHES}; do
		newdoc "${a}"/usr/share/doc/*/README.gentoo README-"${a}".gentoo
	done
}

pkg_preinst() {
	local OLD=${EROOT}/usr/share/edk2-ovmf NEW=${EROOT}/usr/share/edk2/OvmfX64
	if [[ -d ${OLD} && ! -L ${OLD} ]]; then
		{
			rm -vf "${OLD}"/{OVMF_{CODE,CODE.secboot,VARS}.fd,EnrollDefaultKeys.efi,Shell.efi,UefiShell.img} &&
			mkdir -p "${NEW}" &&
			find "${OLD}" -mindepth 1 -maxdepth 1 -execdir mv --update=none-fail -vt "${NEW}"/ {} + &&
			rmdir "${OLD}"
		} || die "unable to replace old directory with compatibility symlink"
	fi
}

pkg_postinst() {
	readme.gentoo_print_elog
}
