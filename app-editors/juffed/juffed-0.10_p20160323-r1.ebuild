# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=5ba17f90ec173e773470bc80ea26bca9a3f093fd
inherit cmake xdg

DESCRIPTION="QScintilla-based tabbed text editor with syntax highlighting"
HOMEPAGE="http://juffed.com/en/"
SRC_URI="https://github.com/Mezomish/${PN}/tarball/${COMMIT} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

RDEPEND="
	app-i18n/enca
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=x11-libs/qscintilla-2.9.4:=[qt5(+)]
"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )

S="${WORKDIR}/Mezomish-${PN}-5ba17f9"

PATCHES=(
	"${FILESDIR}/${P}-qscintilla-2.10.patch"
	"${FILESDIR}/${P}-qt-5.11.patch"
	"${FILESDIR}/${P}-qscintilla-2.10.3.patch"
)

src_prepare() {
	# Upstream version outdated/dysfunctional and CRLF terminated
	cp "${FILESDIR}"/FindQtSingleApplication.cmake cmake/ || die

	cmake_src_prepare

	sed -i -e '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt || die
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DUSE_ENCA=ON
		-DUSE_QT5=ON
		-DUSE_SYSTEM_QTSINGLEAPPLICATION=ON
		-DLIB_SUFFIX=${libdir/lib/}
	)
	cmake_src_configure
}
