# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Tools for manipulating UEFI secure boot platforms"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jejb/efitools.git/snapshot/efitools-1.8.1.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="libressl"

RDEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-apps/util-linux"

DEPEND="${RDEPEND}
	app-crypt/sbsigntool
	dev-perl/File-Slurp
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/1.7.0-Make.rules.patch"
	"${FILESDIR}/${P}-libressl-compatibility.patch"
)

src_prepare() {
	# Respect users CFLAGS
	sed -i -e 's/CFLAGS.*= -O2 -g/CFLAGS += /' Make.rules || die

	# Respect users LDFLAGS
	sed -i -e 's/LDFLAGS/LIBS/g' Make.rules || die
	sed -i -e 's/\$(CC)/& $(LDFLAGS)/g' Makefile || die

	# Run 'default', to apply user patches
	default
}
