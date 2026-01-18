# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edos2unix flag-o-matic

DESCRIPTION="Weak signal ham radio communication with improvements"
HOMEPAGE="https://wsjt-x-improved.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/wsjt-x-improved/wsjtx-${PV}_improved_PLUS_250924_qt6.tgz"

S=${WORKDIR}/wsjtx

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc"

RDEPEND="
	!media-radio/wsjtx
	dev-libs/boost:=[nls,python]
	dev-qt/qtbase:6[concurrent,gui,network,sql,sqlite,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtserialport:6
	dev-qt/qtwebsockets:6
	virtual/libusb:1
	>=media-libs/hamlib-4.0:=
	sci-libs/fftw:3.0=[threads,fortran]
	virtual/fortran
	app-text/asciidoc
	doc? ( dev-ruby/asciidoctor )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools[linguist]"

PATCHES=(
	"${FILESDIR}/wsjtx-2.2.0-werror.patch"
	"${FILESDIR}/wsjtx-2.3.0-drop-docs.patch"
	"${FILESDIR}/wsjtx-clang.patch"
	"${FILESDIR}/wsjtx-3.0.0-fix-sound-dir.patch"
	"${FILESDIR}/wsjtx-3.0.0-gcc16.patch"
	"${FILESDIR}/wsjtx-2.8.0-qt692-audio.patch"
)

DOCS=( AUTHORS BUGS NEWS README THANKS )

src_unpack() {
	unpack ${A}
	unpack "${WORKDIR}/wsjtx-3.0.0/src/wsjtx.tgz"
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
	# fails to compile with -flto (bug #860417)
	filter-lto

	local mycmakeargs=(
		-DWSJT_GENERATE_DOCS="$(usex doc)"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
	)
	append-ldflags -no-pie
	# fix executable stack from fortran nested functions, placing them on the
	# heap. Switch is only supported for newer GCC versions (bug #968790).
	append-fflags $(test-flags-FC -ftrampoline-impl=heap)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm "${D}"/usr/bin/rigctl{,d,com}-wsjtx || die
	rm "${D}"/usr/share/man/man1/rigctl{,d,com}-wsjtx.1 || die
}
