# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/editor}

DESCRIPTION="A file viewer, editor and analyzer for text, binary, and executable files"
HOMEPAGE="http://hte.sourceforge.net/ https://github.com/sebastianbiallas/ht/"
#SRC_URI="mirror://sourceforge/hte/${MY_P}.tar.bz2"
# tarball is done as: 'make dist' and then rename to mention latest commt
SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="X"

RDEPEND="sys-libs/ncurses:0=
	X? ( x11-libs/libX11 )
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	virtual/yacc
	sys-devel/flex"

DOCS=( AUTHORS ChangeLog KNOWNBUGS README TODO )

S=${WORKDIR}/${MY_P/_pre*}

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-tinfo.patch
	"${FILESDIR}"/${PN}-2.1.0-gcc-6-uchar.patch
)

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
