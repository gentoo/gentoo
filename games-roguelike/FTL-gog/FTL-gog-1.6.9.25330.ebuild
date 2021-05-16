# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker

DESCRIPTION="Top-down roguelike space ship simulator"
HOMEPAGE="https://www.gog.com/game/faster_than_light"
SRC_URI="ftl_advanced_edition_${PV//./_}.sh"
RESTRICT="bindist fetch mirror strip test"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

BDEPEND="app-arch/unzip"
RDEPEND="media-libs/freetype
	media-libs/libsdl[X,sound,opengl,video]
	media-libs/libpng
	sys-libs/zlib
	virtual/opengl"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	elog "Please buy and download ${SRC_URI} from"
	elog "https://www.gog.com/game/faster_than_light"
}

src_unpack() {
	unpack_zip "${DISTDIR}/${A}"
}

src_prepare() {
	default
	rm -r support/{xdg*,*.{sh,txt}} || die
	if ! use x86; then
		rm game/data/FTL.x86 || die
	fi
	if ! use amd64; then
		rm game/data/FTL.amd64 || die
	fi

	sed -i start.sh -e '/chmod/d' || die
}

src_install() {
	insinto /opt/gog/FTL
	doins -r .
	fperms +x /opt/gog/FTL/{start.sh,game/FTL,game/data/FTL}

	if use x86; then
		fperms +x /opt/gog/FTL/game/data/FTL.x86
	fi
	if use amd64; then
		fperms +x /opt/gog/FTL/game/data/FTL.amd64
	fi

	make_desktop_entry "/opt/gog/FTL/start.sh" "FTL: Advanced Edition" FTL
	newicon support/icon.png FTL.png
}
