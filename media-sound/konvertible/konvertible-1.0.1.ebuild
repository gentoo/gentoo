# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/konvertible/konvertible-1.0.1.ebuild,v 1.2 2014/03/21 19:51:54 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A program to convert audio formats with FFmpeg"
HOMEPAGE="http://www.kde-apps.org/content/show.php/Konvertible?content=116892"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/116892-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook taglib"

DEPEND="taglib? ( media-libs/taglib )"
RDEPEND="${DEPEND}
	virtual/ffmpeg
"

DOCS=( ChangeLog README TODO )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with taglib)
	)

	kde4-base_src_configure
}
