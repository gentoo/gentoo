# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Backup content from DVD to hard disk"
HOMEPAGE="http://dvdbackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="nls"

RDEPEND=">=media-libs/libdvdread-4.2.0_pre
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
PATCHES=( "${FILESDIR}/libdvdread-6.1.0.diff" )

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-rpath
}
