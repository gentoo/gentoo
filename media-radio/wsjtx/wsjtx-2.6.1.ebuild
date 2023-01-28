# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edos2unix flag-o-matic

DESCRIPTION="Weak signal ham radio communication"
HOMEPAGE="https://physics.princeton.edu//pulsar/K1JT/wsjtx.html"
SRC_URI="mirror://sourceforge/wsjt/${P}.tgz"
S=${WORKDIR}/wsjtx

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/boost:=[nls,python]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtserialport:5
	dev-qt/qtsql:5
	dev-qt/qttest:5
	dev-qt/qtprintsupport:5
	virtual/libusb:1
	>=media-libs/hamlib-4.0:=
	media-libs/portaudio
	sci-libs/fftw:3.0[threads,fortran]
	virtual/fortran
	app-text/asciidoc
	doc? ( dev-ruby/asciidoctor )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.0-werror.patch"
	"${FILESDIR}/${PN}-2.3.0-drop-docs.patch"
	"${FILESDIR}/${PN}-clang.patch"
)

DOCS=( AUTHORS BUGS NEWS README THANKS )

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}/${P/_/-}/src/wsjtx.tgz"
}

src_prepare() {
	edos2unix "${S}/message_aggregator.desktop"
	edos2unix "${S}/wsjtx.desktop"
	edos2unix "${S}/CMakeLists.txt"
	sed -i -e "s/COMMAND \${GZIP_EXECUTABLE}/#  COMMAND/" \
								manpages/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	# fails to complie with -flto (bug #860417)
	filter-lto

	local mycmakeargs=(
		-DWSJT_GENERATE_DOCS="$(usex doc)"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	append-ldflags -no-pie
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm "${D}"/usr/bin/rigctl{,d,com}-wsjtx || die
	rm "${D}"/usr/share/man/man1/rigctl{,d,com}-wsjtx.1 || die
}
