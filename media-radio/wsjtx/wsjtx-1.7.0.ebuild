# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Weak signal ham radio communication"
HOMEPAGE="http://physics.princeton.edu/pulsar/K1JT/wsjtx.html"
SRC_URI="mirror://sourceforge/wsjt/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtserialport:5
	virtual/libusb:1
	media-libs/portaudio
	sci-libs/fftw:3.0[threads]
	virtual/fortran
	app-text/asciidoc
	doc? ( dev-ruby/asciidoctor )"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWSJT_GENERATE_DOCS="$(usex doc)"
		-DWSJT_DOC_DESTINATION="/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	rm "${D}"/usr/bin/rigctl{,d}-wsjtx || die
	rm "${D}"/usr/share/man/man1/rigctl{,d}-wsjtx.1.gz || die
	rm "${D}"/usr/share/doc/${PF}/{copyright,changelog.Debian.gz,INSTALL,COPYING} || die
}
