# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

DESCRIPTION="a free multithreaded file transfer client"
HOMEPAGE="https://github.com/masneyb/gftp"
SRC_URI="https://github.com/masneyb/gftp/releases/download/${PV}/${P}.tar.xz"

# Override gnome.org.eclass's S= (bug #904064)
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk ssl"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses:0=
	sys-libs/readline:0
	gtk? ( x11-libs/gtk+:2 )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/"${P}"-fix-socklen-type.patch
	)

src_configure() {
	gnome2_src_configure \
		$(use_enable gtk gtkport) \
		$(use_enable ssl)
}

src_install() {
	gnome2_src_install
	dodoc docs/USERS-GUIDE
}
