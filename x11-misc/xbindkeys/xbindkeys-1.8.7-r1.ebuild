# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool for launching commands on keystrokes"
SRC_URI="https://www.nongnu.org/${PN}/${P}.tar.gz"
HOMEPAGE="https://www.nongnu.org/xbindkeys/xbindkeys.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="guile tk"

RDEPEND="
	x11-libs/libX11
	guile? ( >=dev-scheme/guile-1.8.4[deprecated] )
	tk? ( dev-lang/tk )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
DOCS="
	AUTHORS BUGS ChangeLog README TODO xbindkeysrc
"

src_configure() {
	econf \
		$(use_enable guile) \
		$(use_enable tk)
}
