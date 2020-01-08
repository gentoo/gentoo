# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="Create, destroy, resize, check, copy partitions and file systems"
HOMEPAGE="https://www.gnu.org/software/parted"
EGIT_REPO_URI="https://git.savannah.gnu.org/git/parted.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+debug device-mapper nls readline selinux static-libs"
RESTRICT="test"

# specific version for gettext needed
# to fix bug 85999
RDEPEND="
	>=sys-fs/e2fsprogs-1.27
	device-mapper? ( >=sys-fs/lvm2-2.02.45 )
	readline? ( >=sys-libs/readline-5.2:0= >=sys-libs/ncurses-5.7-r7:0= )
	selinux? ( sys-libs/libselinux )
	elibc_uclibc? ( dev-libs/libiconv )
"
DEPEND="
	${RDEPEND}
	nls? ( >=sys-devel/gettext-0.12.1-r2 )
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.2-po4a-mandir.patch
)
S=${WORKDIR}/${P/_p*/}

src_prepare() {
	default

	sh ./bootstrap --gnulib-srcdir=gnulib --no-git || die

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
		--disable-gcc-warnings \
		--disable-rpath \
		--disable-silent-rules
}

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS TODO doc/{API,FAT,USER.jp} )

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
