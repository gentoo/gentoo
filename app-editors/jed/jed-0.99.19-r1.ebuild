# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-$(ver_rs 2 -)"
DESCRIPTION="Console S-Lang-based editor"
HOMEPAGE="http://www.jedsoft.org/jed/"
SRC_URI="ftp://space.mit.edu/pub/davis/jed/v${PV%.*}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="X gpm xft"

RDEPEND=">=sys-libs/slang-2
	gpm? ( sys-libs/gpm )
	X? (
		x11-libs/libX11
		xft? (
			>=media-libs/freetype-2
			x11-libs/libXft
		)
	)"
DEPEND="${RDEPEND}
	X? (
		x11-libs/libXt
		x11-base/xorg-proto
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# replace IDE mode with EMACS mode
	sed -i -e 's/\(_Jed_Default_Emulation = \).*/\1"emacs";/' \
		lib/jed.conf || die
	eapply_user
}

src_configure() {
	econf \
		$(use_enable gpm) \
		$(use_enable xft) \
		JED_ROOT="${EPREFIX}"/usr/share/jed
}

src_compile() {
	emake
	use X && emake xjed
}

src_install() {
	emake -j1 DESTDIR="${D}" install

	dodoc changes.txt INSTALL{,.unx} README
	doinfo info/jed*

	insinto /etc
	doins lib/jed.conf
}
