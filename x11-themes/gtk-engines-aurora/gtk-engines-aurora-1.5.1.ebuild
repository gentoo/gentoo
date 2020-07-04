# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_MAJ=$(ver_cut 1-2)

DESCRIPTION="Aurora GTK+ 2.x Theme Engine"
HOMEPAGE="https://www.gnome-look.org/content/show.php?content=56438"
SRC_URI="https://gnome-look.org/CONTENT/content-files/56438-aurora-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPED="virtual/pkgconfig"

S="${WORKDIR}/aurora-${MY_MAJ}"

PATCHES=( "${FILESDIR}"/${P}-glib-2.31.patch )

src_unpack() {
	unpack ${A}
	unpack ./aurora-gtk-engine-${MY_MAJ}.tar.gz
	unpack ./Aurora.tar.bz2
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default

	insinto /usr/share/themes/Aurora
	doins -r ../Aurora/.

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
