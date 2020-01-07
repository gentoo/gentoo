# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit flag-o-matic distutils-r1 virtualx

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="http://www.pygame.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="doc examples midi X"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	>=media-libs/sdl-image-1.2.2[png,jpeg]
	>=media-libs/sdl-mixer-1.2.4
	>=media-libs/sdl-ttf-2.0.6
	>=media-libs/smpeg-0.4.4-r1
	midi? ( media-libs/portmidi )
	X? ( >=media-libs/libsdl-1.2.5[X,video] )
	!X? ( >=media-libs/libsdl-1.2.5 )"
RDEPEND="${DEPEND}"

# various module import and data path issues
RESTRICT=test

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
	PYTHONPATH="${BUILD_DIR}/lib" virtx "${EPYTHON}" -m pygame.tests
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
