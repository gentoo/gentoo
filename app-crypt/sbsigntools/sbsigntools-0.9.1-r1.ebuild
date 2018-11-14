# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PN="${PN::-1}"

inherit eutils autotools

DESCRIPTION="Utilities for signing and verifying files for UEFI Secure Boot"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/sbsigntools.git/"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jejb/${PN}.git/snapshot/${P}.tar.gz
	https://dev.gentoo.org/~tamiko/distfiles/${MY_PN}-0.8-ccan.tar.gz"

LICENSE="GPL-3 LGPL-3 LGPL-2.1 CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/openssl:0=
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
	sys-libs/binutils-libs
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-openssl-1.1.0-compat.patch
)

src_prepare() {
	mv "${WORKDIR}"/lib/ccan "${S}"/lib || die "mv failed"
	rmdir "${WORKDIR}"/lib || die "rmdir failed"

	local iarch
	case ${ARCH} in
		amd64) iarch=x86_64 ;;
		arm64) iarch=aarch64 ;;
		ia64)  iarch=ia64 ;;
		x86)   iarch=ia32 ;;
		*)     die "unsupported architecture: ${ARCH}" ;;
	esac
	sed -i "/^EFI_ARCH=/s:=.*:=${iarch}:" configure.ac || die
	sed -i 's/-m64$/& -march=x86-64/' tests/Makefile.am || die
	sed -i "/^AR /s:=.*:= $(tc-getAR):" lib/ccan/Makefile.in || die #481480

	default
	eautoreconf
}
