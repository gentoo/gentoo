# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="fuse-based filesystem for maintaining configuration files"
HOMEPAGE="https://boklm.eu/copyfs/"
SRC_URI="https://boklm.eu/copyfs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=sys-fs/fuse-2.0:0"
DEPEND="${RDEPEND}
	sys-apps/attr"

PATCHES=(
	# this patch fixes sandbox violations
	"${FILESDIR}"/${P}-gentoo.patch
	# this patch adds support for cleaning up the versions directory
	# the patch is experimental at best, but it's better than your
	# versions directory filling up with unused files
	#
	# patch by stuart@gentoo.org
	"${FILESDIR}"/${PN}-1.0-unlink.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake bindir="${D}"/usr/bin mandir="${D}"/usr/share/man install
}
