# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/k4guitune/k4guitune-1.1.1.ebuild,v 1.2 2014/03/21 19:43:37 johu Exp $

EAPI=5

KDE_HANDBOOK=optional
inherit kde4-base

DESCRIPTION="A program to tune a musical instrument using your computer and it's mic- or line- input"
HOMEPAGE="http://wspinell.altervista.org/k4guitune/ http://www.kde-apps.org/content/show.php/K4Guitune?content=117669"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/117669-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="=sci-libs/fftw-3*"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}/${P}-desktop_entry.patch" )

src_prepare() {
	kde4-base_src_prepare

	sed -e '/set[[:space:]]*([[:space:]]*HTML_INSTALL_DIR/s/^/# DISABLED /' \
		-i CMakeLists.txt || die
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build handbook doc)
	)

	kde4-base_src_configure
}
