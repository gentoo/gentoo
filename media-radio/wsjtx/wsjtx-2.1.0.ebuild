# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

MY_P=${P/_/-}

DESCRIPTION="Weak signal ham radio communication"
HOMEPAGE="http://physics.princeton.edu/pulsar/K1JT/wsjtx.html"
SRC_URI="mirror://sourceforge/wsjt/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtserialport:5
	dev-qt/qtsql:5
	dev-qt/qtprintsupport:5
	virtual/libusb:1
	media-libs/hamlib
	media-libs/portaudio
	sci-libs/fftw:3.0[threads,fortran]
	virtual/fortran
	app-text/asciidoc
	doc? ( dev-ruby/asciidoctor )"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools
	"

S=${WORKDIR}/wsjtx

PATCHES=( "${FILESDIR}/${PN}-2.0.1-hamlib.patch"
		  "${FILESDIR}/${PN}-fix-unicode.patch"
		  "${FILESDIR}/${PN}-drop-docs.patch" )

DOCS=( AUTHORS BUGS NEWS README THANKS )

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}/${MY_P}/src/wsjtx.tgz"
}

src_configure() {
	cmake_comment_add_subdirectory debian

	local mycmakeargs=(
		-DWSJT_GENERATE_DOCS="$(usex doc)"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	rm "${D}"/usr/bin/rigctl{,d}-wsjtx || die
	rm "${D}"/usr/share/man/man1/rigctl{,d,com}-wsjtx.1.gz || die
}
