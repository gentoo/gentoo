# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/about/"
SRC_URI="https://dev.gentoo.org/~blueness/f2fs-tools/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/4"
KEYWORDS="amd64 ~arm ~arm64 ~mips ppc ~ppc64 ~x86"
IUSE="selinux"

RDEPEND="
	sys-apps/util-linux
	selinux? ( sys-libs/libselinux )"
DEPEND="$RDEPEND"

PATCHES=( "${FILESDIR}"/${P}-fibmap-include-config_h.patch )

src_configure() {
	#This is required to install to /sbin, bug #481110
	econf \
		--bindir="${EPREFIX}"/sbin \
		--disable-static \
		$(use_with selinux)
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
