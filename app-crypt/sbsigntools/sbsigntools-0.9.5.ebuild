# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN::-1}"

inherit autotools toolchain-funcs

DESCRIPTION="Utilities for signing and verifying files for UEFI Secure Boot"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/sbsigntools.git/"
SRC_URI="
	https://git.kernel.org/pub/scm/linux/kernel/git/jejb/${PN}.git/snapshot/${P}.tar.gz
	https://dev.gentoo.org/~tamiko/distfiles/${MY_PN}-0.8-ccan.tar.gz
"

LICENSE="GPL-3 LGPL-3 LGPL-2.1 CC0-1.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE=""

RDEPEND="
	dev-libs/openssl:=
	sys-apps/util-linux
"
DEPEND="
	${RDEPEND}
	sys-boot/gnu-efi
	sys-libs/binutils-libs
"
BDEPEND="
	dev-perl/Locale-gettext
	sys-apps/help2man
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.4-no-werror.patch
)

src_prepare() {
	mv "${WORKDIR}"/lib/ccan "${S}"/lib || die "mv failed"
	rmdir "${WORKDIR}"/lib || die "rmdir failed"

	local iarch
	case ${ARCH} in
		amd64) iarch=x86_64 ;;
		arm64) iarch=aarch64 ;;
		ia64)  iarch=ia64 ;;
		riscv) iarch=riscv64 ;;
		x86)   iarch=ia32 ;;
		*)     die "unsupported architecture: ${ARCH}" ;;
	esac
	sed -i "/^EFI_ARCH=/s:=.*:=${iarch}:" configure.ac || die
	sed -i 's/-m64$/& -march=x86-64/' tests/Makefile.am || die
	sed -i "/^AR /s:=.*:= $(tc-getAR):" lib/ccan/Makefile.in || die #481480

	default
	eautoreconf
}
