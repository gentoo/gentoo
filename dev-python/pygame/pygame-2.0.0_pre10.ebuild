# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit flag-o-matic distutils-r1 virtualx

MY_PV=${PV/_pre/.dev}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="https://www.pygame.org/"
SRC_URI="
	https://github.com/pygame/pygame/releases/download/${MY_PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples midi opengl test X"
RESTRICT="!test? ( test )"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=media-libs/sdl2-image-1.2.2[png,jpeg]
	>=media-libs/sdl2-mixer-1.2.4
	>=media-libs/sdl2-ttf-2.0.6
	>=media-libs/smpeg2-0.4.4-r1
	midi? ( media-libs/portmidi )
	X? ( >=media-libs/libsdl2-1.2.5[opengl?,video,X] )
	!X? ( >=media-libs/libsdl2-1.2.5 )"
RDEPEND="${DEPEND}"
# util-linux provides script
BDEPEND="
	test? ( sys-apps/util-linux )"

PATCHES=(
	"${FILESDIR}"/${P}-py39.patch
)

python_configure() {
	PORTMIDI_INC_PORTTIME=1 LOCALBASE="${EPREFIX}/usr" \
		"${EPYTHON}" "${S}"/buildconfig/config.py -auto || die

	# Disable automagic dependency on PortMidi.
	if ! use midi; then
		sed -e "s:^pypm :#&:" -i Setup || die "sed failed"
	fi
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local -x PYTHONPATH=
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

	use examples && dodoc -r examples
}
