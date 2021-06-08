# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tools for manipulating UEFI secure boot platforms"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="static"

LIB_DEPEND="dev-libs/openssl:0=[static-libs(+)]"

RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	sys-apps/util-linux"

DEPEND="${RDEPEND}
	app-crypt/sbsigntools
	dev-perl/File-Slurp
	static? ( ${LIB_DEPEND} )
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/1.7.0-Make.rules.patch"
)

src_prepare() {
	if use static; then
		append-ldflags -static
		sed -i "s/-lcrypto\b/$($(tc-getPKG_CONFIG) --static --libs libcrypto)/g" \
			Makefile || die
	fi

	# Respect users CFLAGS
	sed -i -e 's/CFLAGS.*= -O2 -g/CFLAGS += /' Make.rules || die

	# Respect users LDFLAGS
	sed -i -e 's/LDFLAGS/LIBS/g' Make.rules || die
	sed -i -e 's/\$(CC)/& $(LDFLAGS)/g' Makefile || die

	# Run 'default', to apply user patches
	default
}
