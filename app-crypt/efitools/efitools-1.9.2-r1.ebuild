# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tools for manipulating UEFI secure boot platforms"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="static"

LIB_DEPEND="dev-libs/openssl:=[static-libs(+)]"

RDEPEND="
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	sys-boot/gnu-efi"
BDEPEND="
	app-crypt/sbsigntools
	dev-perl/File-Slurp
	sys-apps/help2man
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/1.9.2-clang16.patch
	"${FILESDIR}"/1.9.2-Makefile.patch
)

src_prepare() {
	default

	# Let it build with clang
	if tc-is-clang; then
		sed -i -e 's/-fno-toplevel-reorder//g' Make.rules || die
	fi

	if use static; then
		append-ldflags -static
		export STATIC_FLAG=--static
	fi
}

src_configure() {
	tc-export AR CC LD NM OBJCOPY PKG_CONFIG
}
