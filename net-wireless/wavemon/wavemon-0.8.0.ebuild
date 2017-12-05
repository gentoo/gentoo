# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Ncurses based monitor for IEEE 802.11 wireless LAN cards"
HOMEPAGE="https://github.com/uoaerg/wavemon/"
SRC_URI="https://github.com/uoaerg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86"

IUSE="caps"
RDEPEND="dev-libs/libnl:3
	sys-libs/ncurses:0=
	caps? ( sys-libs/libcap )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )
PATCHES=(
	"${FILESDIR}/${PN}-0.7.6-ncurses-tinfo.patch"
	"${FILESDIR}/${PN}-0.8.0-build.patch"
)

src_prepare() {
	# Do not install docs to /usr/share
	sed -i -e '/^install:/s/install-docs//' Makefile.in || die 'sed on Makefile.in failed'

	# automagic on libcap, discovered in bug #448406
	use caps || export ac_cv_lib_cap_cap_get_flag=false

	# Respect CC
	tc-export CC

	default_src_prepare
	eautoreconf
}

src_install() {
	default_src_install
	# Install man files manually(bug #397807)
	doman wavemon.1
	doman wavemonrc.5
}
