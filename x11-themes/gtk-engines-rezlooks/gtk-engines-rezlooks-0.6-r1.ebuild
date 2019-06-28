# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Rezlooks GTK+ Engine"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=39179"
SRC_URI="http://www.gnome-look.org/content/files/39179-rezlooks-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND=">=x11-libs/gtk+-2.8:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.6-glib-single-include.patch"
)

S=${WORKDIR}/rezlooks-${PV}

src_prepare() {
	default
	eautoreconf # required for interix
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
