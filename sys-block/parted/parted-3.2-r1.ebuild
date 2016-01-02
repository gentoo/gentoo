# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="Create, destroy, resize, check, copy partitions and file systems"
HOMEPAGE="https://www.gnu.org/software/parted"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+debug device-mapper nls readline selinux static-libs"
RESTRICT="test"

# specific version for gettext needed
# to fix bug 85999
RDEPEND="
	>=sys-fs/e2fsprogs-1.27
	>=sys-libs/ncurses-5.7-r7:0=
	device-mapper? ( >=sys-fs/lvm2-2.02.45 )
	readline? ( >=sys-libs/readline-5.2:0= )
	selinux? ( sys-libs/libselinux )
	elibc_uclibc? ( dev-libs/libiconv )
"
DEPEND="
	${RDEPEND}
	nls? ( >=sys-devel/gettext-0.12.1-r2 )
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.2-devmapper.patch \
		"${FILESDIR}"/${PN}-3.2-po4a-mandir.patch \
		"${FILESDIR}"/${PN}-3.2-fix-resizing-FAT16.patch

	eautoreconf
}

src_configure() {
	use elibc_uclibc && append-libs -liconv
	econf \
		$(use_enable debug) \
		$(use_enable device-mapper) \
		$(use_enable nls) \
		$(use_enable selinux) \
		$(use_enable static-libs static) \
		$(use_with readline) \
		--disable-rpath \
		--disable-silent-rules
}

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO doc/{API,FAT,USER.jp} )

src_install() {
	default
	prune_libtool_files
}
