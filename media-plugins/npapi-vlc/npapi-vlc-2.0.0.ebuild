# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/npapi-vlc.git"
else
	KEYWORDS="amd64 ~ppc64 x86"
	DEPEND="app-arch/xz-utils"
	SRC_URI="http://download.videolan.org/pub/videolan/vlc/${PV}/${P}.tar.xz"
fi

DESCRIPTION="Mozilla plugin based on VLC"
HOMEPAGE="http://www.videolan.org/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="gtk"

RDEPEND="
	>=media-video/vlc-1.1
	x11-libs/libX11
	!gtk? (
		x11-libs/libXpm
		x11-libs/libSM
		x11-libs/libICE
	)
	gtk? ( x11-libs/gtk+:2 )
	!<media-video/vlc-1.2[nsplugin]"
DEPEND+="
	${RDEPEND}
	virtual/pkgconfig
	>=net-misc/npapi-sdk-0.27"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	econf $(use_with gtk)
}

src_install() {
	emake DESTDIR="${D}" npvlcdir="/usr/$(get_libdir)/nsbrowser/plugins" install
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
