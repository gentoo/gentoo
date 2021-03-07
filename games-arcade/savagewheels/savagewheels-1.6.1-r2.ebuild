# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="2D car crashing game similar to the old classic Destruction Derby"
HOMEPAGE="https://github.com/petarov/savagewheels"

GAMEDATA="${PN}-gamedata-1.4.0"

SRC_URI="
	https://github.com/petarov/savagewheels/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/petarov/savagewheels/releases/download/v1.4/${PN}-gamedata.tar.gz -> ${GAMEDATA}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sound"

RDEPEND="
	media-libs/libsdl[joystick]
	sound? ( media-libs/sdl-mixer[mod,modplug] )
"
DEPEND="${RDEPEND}"

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
		-DCMAKE_INSTALL_DATADIR="${EPREFIX}"/usr/share/${PN}
		-DCMAKE_INSTALL_LIBEXECDIR="${EPREFIX}"/usr/libexec/${PN}
		-DSOUND=$(usex sound YES NO) # yes, 'NO' is important here. bug 773439
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}/${GAMEDATA}/."
}
