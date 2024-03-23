# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MY_P="${P/_/}"
DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client"
HOMEPAGE="http://abook.sourceforge.net/"
SRC_URI="http://abook.sourceforge.net/devel/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="nls"

RDEPEND="
	sys-libs/ncurses:=
	sys-libs/readline:=
	dev-libs/libvformat
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${MY_P}"

DOCS=( BUGS ChangeLog FAQ README TODO sample.abookrc )

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.1-use-PKG_CHECK_MODULES-for-ncurses.patch
	"${FILESDIR}"/${PN}-0.6.1-use-newer-macro-for-readline.patch
	"${FILESDIR}"/${PN}-0.6.1-vformat.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-vformat \
		$(use_enable nls)
}

src_compile() {
	# bug #570428
	append-cflags -std=gnu89

	emake CFLAGS="${CFLAGS}"
}
