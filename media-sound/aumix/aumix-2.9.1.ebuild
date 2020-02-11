# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Aumix volume/mixer control program"
HOMEPAGE="http://jpj.net/~trevor/aumix.html"
SRC_URI="http://jpj.net/~trevor/aumix/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE="gpm gtk nls"

RDEPEND="sys-libs/ncurses:0=
	gpm? ( sys-libs/gpm )
	gtk? ( x11-libs/gtk+:2 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${P}-tinfo.patch" #578722
)

src_prepare() {
	default
	eautoreconf #578722
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(usex gtk '' --without-gtk)
		$(usex gpm '' --without-gpm)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/aumix.rc6 aumix

	if use gtk; then
		doicon data/aumix.xpm
		make_desktop_entry aumix Aumix
	fi
}
