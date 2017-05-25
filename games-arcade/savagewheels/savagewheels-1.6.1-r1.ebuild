# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="2D car crashing game similar to the old classic Destruction Derby."
HOMEPAGE="https://github.com/petarov/savagewheels"

GAMEDATA="${PN}-gamedata-1.4.0"

SRC_URI="
	https://github.com/petarov/savagewheels/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/petarov/savagewheels/releases/download/v1.4/${PN}-gamedata.tar.gz -> ${GAMEDATA}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="fmod sound"

RDEPEND="
	media-libs/libsdl
	sound? (
		!fmod? ( media-libs/sdl-mixer[mod,modplug] )
		fmod? ( >=media-libs/fmod-4.38.00 )
	)"

DEPEND="${RDEPEND}"

REQUIRED_USE="fmod? ( sound )"

src_unpack() {
	unpack ${P}.tar.gz

	cp "${FILESDIR}/${PN}.in" "${S}" || die
	mkdir "${WORKDIR}/${GAMEDATA}" ||
		die "Failed to make directory: ${WORKDIR}/${GAMEDATA}"
	cd "${WORKDIR}/${GAMEDATA}" ||
		die "Unable to change into directory: ${WORKDIR}/${GAMEDATA}"
	unpack "${GAMEDATA}.tar.gz"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DATADIR=share/${PN}
		-DCMAKE_INSTALL_LIBEXECDIR=libexec/${PN}
		$(usex sound $(usex fmod '-DSOUND=FMOD -DFMOD_PATH=/opt/fmodex/api' '-DSOUND=YES') '-DSOUND=NO')
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}/${GAMEDATA}/."
}
