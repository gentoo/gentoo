# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

# Change these as releases changes
IMAGES="images-2005-01-06"
LEVELS="levels-2005-01-06"
MODELS="models-2005-01-06"
MUSICS="musics-2005-01-06"
SOUNDS="sounds"

DESCRIPTION="Bomberman clone w/network support for up to 6 players"
HOMEPAGE="http://xblast.sourceforge.net/"
SRC_URI="https://download.sourceforge.net/xblast/${P}.tar.gz
	https://download.sourceforge.net/xblast/${IMAGES}.tar.gz
	https://download.sourceforge.net/xblast/${LEVELS}.tar.gz
	https://download.sourceforge.net/xblast/${MODELS}.tar.gz
	https://download.sourceforge.net/xblast/${MUSICS}.tar.gz
	https://download.sourceforge.net/xblast/${SOUNDS}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libpng:0
	x11-libs/libICE
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_prepare() {
	default

	eautoreconf #255857
}

src_configure() {
	econf \
		--with-otherdatadir=/usr/share/${PN} \
		--enable-sound
}

src_install() {
	local IMAGE_INSTALL_DIR="/usr/share/${PN}/image"

	default

	# Images
	dodir "${IMAGE_INSTALL_DIR}"
	cp -pPR "${WORKDIR}/${IMAGES}"/* "${D}/${IMAGE_INSTALL_DIR}" || die

	# Levels
	insinto "/usr/share/${PN}/level"
	doins "${WORKDIR}/${LEVELS}"/*

	# Models
	insinto "/usr/share/${PN}/image/sprite"
	doins "${WORKDIR}/${MODELS}"/*

	# Music and sound
	insinto "/usr/share/${PN}/sounds"
	doins "${WORKDIR}/${MUSICS}"/* "${WORKDIR}/${SOUNDS}"/*

	# Cleanup
	find "${D}" -name Imakefile -exec rm \{\} \;
}
