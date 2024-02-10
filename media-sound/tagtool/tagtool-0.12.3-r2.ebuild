# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Audio Tag Tool Ogg/Mp3 Tagger"
HOMEPAGE="https://sourceforge.net/projects/tagtool/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="mp3 +vorbis"
REQUIRED_USE="|| ( mp3 vorbis )"

RDEPEND="
	x11-libs/gtk+:2
	>=gnome-base/libglade-2.6
	mp3? ( >=media-libs/id3lib-3.8.3-r6 )
	vorbis? ( >=media-libs/libvorbis-1 )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-QA-desktop.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable mp3) \
		$(use_enable vorbis)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		GNOME_SYSCONFDIR="${ED}"/etc \
		sysdir="${ED}"/usr/share/applets/Multimedia \
		install
	einstalldocs
}
