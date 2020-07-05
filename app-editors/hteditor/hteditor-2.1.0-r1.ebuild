# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic toolchain-funcs

MY_P=${P/editor}

DESCRIPTION="A file viewer, editor and analyzer for text, binary, and executable files"
HOMEPAGE="http://hte.sourceforge.net/ https://github.com/sebastianbiallas/ht/"
SRC_URI="mirror://sourceforge/hte/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="X"

RDEPEND="sys-libs/ncurses:0=
	X? ( x11-libs/libX11 )
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex"

DOCS=( AUTHORS ChangeLog KNOWNBUGS README TODO )

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-gcc-7.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-gcc-6-uchar.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-AR.patch
)

src_prepare() {
	default
	eautoreconf

	# Many literals are concatenated with macro definitions.
	# Instead of patching them all let's pick old c++ standard
	# and port to c++11 upstream.
	# https://bugs.gentoo.org/729252
	append-cxxflags -std=c++98
}

src_configure() {
	econf \
		$(use_enable X x11-textmode) \
		--enable-maintainermode
}

src_install() {
	#For prefix
	chmod u+x "${S}/install-sh"

	local HTML_DOCS="doc/*.html"
	doinfo doc/*.info

	default
}
