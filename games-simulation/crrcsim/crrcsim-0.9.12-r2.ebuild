# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WANT_AUTOMAKE="1.10"
inherit autotools eutils gnome2-utils

DESCRIPTION="model-airplane flight simulation program"
HOMEPAGE="https://sourceforge.net/projects/crrcsim/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="portaudio"

RDEPEND="
	media-libs/libsdl[X,sound,joystick,opengl,video]
	media-libs/plib
	sci-mathematics/cgal
	portaudio? ( media-libs/portaudio )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-buildsystem.patch
)

src_prepare() {
	default

	if has_version "sci-mathematics/cgal[gmp(+)]" ; then
		eapply "${FILESDIR}"/${PN}-cgal_gmp.patch
	fi
	eautoreconf
}

src_configure() {
	econf \
		--datadir="/usr/share" \
		--datarootdir="${EPREFIX%/}/usr/share" \
		--docdir="${EPREFIX%/}/usr/share/doc/${PF}" \
		$(use_with portaudio)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS HISTORY NEWS README
	doicon -s 32 packages/icons/${PN}.png
	make_desktop_entry ${PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
