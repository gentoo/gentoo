# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit flag-o-matic distutils-r1

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="https://www.pygame.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="doc examples midi opengl test X"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=media-libs/sdl-image-1.2.2[png,jpeg]
	>=media-libs/sdl-mixer-1.2.4
	>=media-libs/sdl-ttf-2.0.6
	>=media-libs/smpeg-0.4.4-r1
	midi? ( media-libs/portmidi )
	X? ( >=media-libs/libsdl-1.2.5[opengl?,video,X] )
	!X? ( >=media-libs/libsdl-1.2.5 )"
DEPEND="${RDEPEND}
	test? (
		media-libs/sdl-image[gif,png,jpeg]
		media-libs/sdl-mixer[mp3,vorbis,wav]
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
	# segfaults on Xvfb
	rm test/scrap_test.py || die
	# backport from git master (clock() isn't used)
	sed -i -e '/from time import clock/d' test/math_test.py || die

	distutils-r1_src_prepare
}

python_configure() {
	PORTMIDI_INC_PORTTIME=1 LOCALBASE="${EPREFIX}/usr" \
		"${EPYTHON}" "${S}"/buildconfig/config.py -auto

	if ! use X; then
		sed -e "s:^scrap :#&:" -i Setup || die "sed failed"
	fi

	# Disable automagic dependency on PortMidi.
	if ! use midi; then
		sed -e "s:^pypm :#&:" -i Setup || die "sed failed"
	fi
}

python_compile() {
	if [[ ${EPYTHON} == python2* ]]; then
		local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}

		append-flags -fno-strict-aliasing
	fi

	distutils-r1_python_compile
}

python_test() {
	local -x PYTHONPATH=
	local -x SDL_VIDEODRIVER=dummy
	local -x SDL_AUDIODRIVER=disk
	distutils_install_for_testing
	script -eqc "${EPYTHON} -m pygame.tests" || die
}

python_install() {
	distutils-r1_python_install

	# Bug #497720
	rm -fr "${D}"$(python_get_sitedir)/pygame/{docs,examples,tests}/ || die
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		docinto html
		dodoc -r docs/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
