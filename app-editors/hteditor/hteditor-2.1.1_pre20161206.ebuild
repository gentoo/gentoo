# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/editor}

DESCRIPTION="File viewer, editor and analyzer for text, binary, and executable files"
HOMEPAGE="https://hte.sourceforge.net/ https://github.com/sebastianbiallas/ht/"
#SRC_URI="mirror://sourceforge/hte/${MY_P}.tar.bz2"
# tarball is done as: 'make dist' and then rename to mention latest commt
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~riscv x86"
IUSE="X"

RDEPEND="sys-libs/ncurses:0=
	X? ( x11-libs/libX11 )
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	app-alternatives/yacc
	app-alternatives/lex"

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
