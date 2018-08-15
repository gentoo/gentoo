# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit autotools eutils toolchain-funcs

DESCRIPTION="fuse-based filesystem for maintaining configuration files"
HOMEPAGE="https://boklm.eu/copyfs/"
SRC_URI="https://boklm.eu/copyfs/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND=">=sys-fs/fuse-2.0
	sys-apps/attr"
RDEPEND="${DEPEND}"

src_prepare() {
	# this patch fixes sandbox violations
	epatch "${FILESDIR}"/${P}-gentoo.patch

	# this patch adds support for cleaning up the versions directory
	# the patch is experimental at best, but it's better than your
	# versions directory filling up with unused files
	#
	# patch by stuart@gentoo.org
	epatch "${FILESDIR}"/${PN}-1.0-unlink.patch
	eautoreconf
}

src_configure() {
	econf --bindir="${D}/usr/bin" --mandir="${D}/usr/share/man"
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
