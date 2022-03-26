# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="https://www.pygame.org/"
SRC_URI="
	https://github.com/pygame/pygame/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86"
IUSE="examples midi opengl test X"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/freetype
	media-libs/libpng:0=
	>=media-libs/sdl2-image-1.2.2
	>=media-libs/sdl2-mixer-1.2.4
	>=media-libs/sdl2-ttf-2.0.6
	>=media-libs/smpeg2-0.4.4-r1
	virtual/jpeg
	midi? ( media-libs/portmidi )
	X? ( >=media-libs/libsdl2-1.2.5[opengl?,threads,video,X] )
	!X? ( >=media-libs/libsdl2-1.2.5[threads] )"
DEPEND="${RDEPEND}
	test? (
		media-libs/sdl2-image[gif,jpeg,png,tiff]
		media-libs/sdl2-mixer[mp3,vorbis,wav]
	)"
# fontconfig used for fc-list
RDEPEND+="
	media-libs/fontconfig"
# util-linux provides script
BDEPEND="
	test? (
		media-libs/fontconfig
		sys-apps/util-linux
	)"

src_prepare() {
	if ! use midi; then
		rm test/midi_test.py || die
	fi
	distutils-r1_src_prepare
}

python_configure() {
	PORTMIDI_INC_PORTTIME=1 LOCALBASE="${EPREFIX}/usr" \
		"${EPYTHON}" "${S}"/buildconfig/config.py -auto || die

	# Disable automagic dependency on PortMidi.
	if ! use midi; then
		sed -e "s:^pypm :#&:" -i Setup || die "sed failed"
	fi
}

python_test() {
	local -x PYTHONPATH=${BUILD_DIR}/install/lib
	local -x SDL_VIDEODRIVER=dummy
	local -x SDL_AUDIODRIVER=disk
	script -eqc "${EPYTHON} -m pygame.tests -v" || die
}

python_install() {
	distutils-r1_python_install

	# Bug #497720
	rm -fr "${D}$(python_get_sitedir)"/pygame/{docs,examples,tests}/ || die
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
