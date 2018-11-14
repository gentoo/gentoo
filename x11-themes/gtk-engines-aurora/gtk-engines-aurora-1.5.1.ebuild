# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils versionator

MY_MAJ=$(get_version_component_range 1-2)

DESCRIPTION="Aurora GTK+ 2.x Theme Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=56438"
SRC_URI="http://gnome-look.org/CONTENT/content-files/56438-aurora-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.10:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/aurora-${MY_MAJ}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	tar -xzf aurora-gtk-engine-${MY_MAJ}.tar.gz || die
	tar -xjf Aurora.tar.bz2 || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-glib-2.31.patch
}

src_configure() {
	econf --enable-animation
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	insinto /usr/share/themes/Aurora
	doins -r ../Aurora/*

	find "${ED}"/usr -name '*.la' -type f -exec rm -f {} +
}
