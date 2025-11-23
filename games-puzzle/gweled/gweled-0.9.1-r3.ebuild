# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Bejeweled clone game"
HOMEPAGE="https://launchpad.net/gweled/"
SRC_URI="https://launchpad.net/gweled/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	dev-libs/glib:2
	gnome-base/librsvg:2
	media-libs/libmikmod
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-librsvg.patch
	"${FILESDIR}"/${P}-implicit-decl.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		--localstatedir="${EPREFIX}"/var
		--with-scores-user=
		--with-scores-group=gamestat
	)

	econf "${econfargs[@]}"
}

src_install() {
	default

	fperms 2751 /usr/bin/${PN}
	fperms 660 /var/games/${PN}.{Normal,Timed}.scores
}
