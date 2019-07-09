# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic xdg cmake-utils

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="https://celestia.space"
if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CelestiaProject/Celestia.git"
else
	# Old URI! Please update once we have a release > v1.6.1
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="glut gtk nls +qt5 theora"

REQUIRED_USE="|| ( glut gtk qt5 )"

BDEPEND="
	dev-cpp/eigen
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="
	>=dev-lang/lua-5.1:*
	dev-libs/libfmt
	media-libs/glew:0
	media-libs/libpng:0=
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
	glut? ( media-libs/freeglut )
	gtk? (
		x11-libs/gtk+:2
		>=x11-libs/gtkglext-1.0
		x11-libs/gdk-pixbuf:2
		x11-libs/pango
	)
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
	cmake-utils_src_prepare

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
		-DENABLE_GTK="$(usex gtk)"
		-DENABLE_QT="$(usex qt5)"
		-DENABLE_WIN=OFF
		-DENABLE_THEORA="$(usex theora)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local size
	for size in 16 22 32 48 ; do
		newicon -s ${size} "${S}"/src/celestia/kde/data/hi${size}-app-${PN}.png ${PN}.png
	done

	use glut && domenu ${PN}.desktop
	local ui
	for ui in gtk qt5 ; do
		if use ${ui} ; then
			sed \
				-e "/^Name/s@\$@ (${ui} interface)@" \
				-e "/^Exec/s@${PN}@${PN}-${ui/qt5/qt}@" \
				${PN}.desktop > "${T}"/${PN}-${ui}.desktop || die
			domenu "${T}"/${PN}-${ui}.desktop
		fi
	done
	dodoc AUTHORS README TRANSLATORS *.txt
}
