# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic xdg cmake

if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CelestiaProject/Celestia.git"
else
	SRC_URI="https://github.com/${PN^}Project/${PN^}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="https://celestia.space"

LICENSE="GPL-2"
SLOT="0"
IUSE="glut nls +qt5 theora"

REQUIRED_USE="|| ( glut qt5 )"

BDEPEND="
	dev-cpp/eigen
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="
	>=dev-lang/lua-5.1:*
	dev-libs/libfmt:=
	media-libs/glew:0
	media-libs/libpng:0=
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
	glut? ( media-libs/freeglut )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	theora? (
		media-libs/libogg
		media-libs/libtheora
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	# make better desktop files
	"${FILESDIR}"/${PN}-1.5.0-desktop.patch
	# add a ~/.celestia for extra directories
	"${FILESDIR}"/${PN}-1.6.99-cfg.patch
)

src_prepare() {
	cmake_src_prepare

	filter-flags "-funroll-loops -frerun-loop-opt"

	### This version of Celestia has a bug in the font rendering and
	### requires -fsigned-char. We should be able to force this flag
	### on all architectures. See bug #316573.
	append-flags "-fsigned-char"
}

src_configure() {
	# force lua. Seems still to be inevitable
	local mycmakeargs=(
		#-DENABLE_CELX="$(usex lua)"
		-DENABLE_CELX=ON
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_GLUT="$(usex glut)"
		-DENABLE_GTK=OFF
		-DENABLE_QT="$(usex qt5)"
		-DENABLE_WIN=OFF
		-DENABLE_THEORA="$(usex theora)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	local size
	for size in 16 22 32 48 ; do
		newicon -s ${size} "${S}"/src/celestia/kde/data/hi${size}-app-${PN}.png ${PN}.png
	done
	newicon -s 128 "${S}"/src/celestia/gtk/data/${PN}-logo.png ${PN}.png
	doicon -s scalable "${S}"/src/celestia/gtk/data/${PN}.svg

	use glut && domenu ${PN}.desktop
	if use qt5 ; then
		sed \
			-e "/^Name/s@\$@ (qt5 interface)@" \
			-e "/^Exec/s@${PN}@${PN}-qt@" \
			${PN}.desktop > "${T}"/${PN}-qt5.desktop || die
		domenu "${T}"/${PN}-qt5.desktop
	fi
	dodoc AUTHORS README TRANSLATORS *.txt
}
