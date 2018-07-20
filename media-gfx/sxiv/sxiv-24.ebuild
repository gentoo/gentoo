# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils xdg-utils gnome2-utils savedconfig toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/muennich/sxiv.git"
	inherit git-r3
else
	SRC_URI="https://github.com/muennich/sxiv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Simple (or small or suckless) X Image Viewer"
HOMEPAGE="https://github.com/muennich/sxiv/"

LICENSE="GPL-2"
SLOT="0"
IUSE="exif gif"

RDEPEND="
	exif? ( media-libs/libexif )
	gif? ( media-libs/giflib:0= )
	media-libs/imlib2[X,gif?]
	x11-libs/libX11
	x11-libs/libXft
"
DEPEND="${RDEPEND}"

src_prepare() {
	restore_config config.h
	default
}

src_compile() {
	emake V=1 CC="$(tc-getCC)" HAVE_LIBEXIF=$(usex exif 1 0) HAVE_GIFLIB=$(usex gif 1 0)
}

src_install() {
	emake DESTDIR="${ED}" PREFIX=/usr install
	emake -C icon DESTDIR="${ED}" PREFIX=/usr install
	dodoc README.md
	domenu sxiv.desktop

	save_config config.h
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
