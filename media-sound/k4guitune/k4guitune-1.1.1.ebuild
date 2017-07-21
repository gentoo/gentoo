# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# QT3SUPPORT_REQUIRED
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Program to tune musical instruments using your computer's mic- or line- input"
HOMEPAGE="http://wspinell.altervista.org/k4guitune/ http://www.kde-apps.org/content/show.php/K4Guitune?content=117669"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/117669-${P}.tar.gz"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}/${P}-desktop_entry.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_doc=$(usex handbook)
	)

	kde4-base_src_configure
}
