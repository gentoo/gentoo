# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit cmake-utils multilib python-r1 virtualx

MY_P="${PN}-qt4.8+${PV}"

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://qt-project.org/wiki/PySide"
SRC_URI="http://download.qt-project.org/official_releases/${PN}/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="X declarative designer help multimedia opengl phonon script scripttools sql svg test webkit xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	declarative? ( X )
	designer? ( X )
	help? ( X )
	multimedia? ( X )
	opengl? ( X )
	phonon? ( X )
	scripttools? ( X script )
	sql? ( X )
	svg? ( X )
	test? ( X )
	webkit? ( X )
"

# Minimal supported version of Qt.
QT_PV="4.8.5:4"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken-${PV}[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}
	X? (
		>=dev-qt/qtgui-${QT_PV}[accessibility]
		>=dev-qt/qttest-${QT_PV}
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV} )
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	phonon? ( || (
		media-libs/phonon[qt4(+)]
		>=dev-qt/qtphonon-${QT_PV}
	) )
	script? ( >=dev-qt/qtscript-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV}[accessibility] )
	webkit? ( >=dev-qt/qtwebkit-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV} )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtgui-${QT_PV}
"

S=${WORKDIR}/${MY_P}

DOCS=( ChangeLog )

src_prepare() {
	# Fix generated pkgconfig file to require the shiboken
	# library suffixed with the correct python version.
	sed -i -e '/^Requires:/ s/shiboken$/&@SHIBOKEN_PYTHON_SUFFIX@/' \
		libpyside/pyside.pc.in || die

	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_disable X QtGui)
		$(cmake-utils_use_disable X QtTest)
		$(cmake-utils_use_disable declarative QtDeclarative)
		$(cmake-utils_use_disable designer QtDesigner)
		$(cmake-utils_use_disable designer QtUiTools)
		$(cmake-utils_use_disable help QtHelp)
		$(cmake-utils_use_disable multimedia QtMultimedia)
		$(cmake-utils_use_disable opengl QtOpenGL)
		$(cmake-utils_use_disable phonon)
		$(cmake-utils_use_disable script QtScript)
		$(cmake-utils_use_disable scripttools QtScriptTools)
		$(cmake-utils_use_disable sql QtSql)
		$(cmake-utils_use_disable svg QtSvg)
		$(cmake-utils_use_disable webkit QtWebKit)
		$(cmake-utils_use_disable xmlpatterns QtXmlPatterns)
	)

	if use phonon && has_version "media-libs/phonon[qt4(+)]"; then
		# bug 475786
		mycmakeargs+=(
			-DQT_PHONON_INCLUDE_DIR="${EPREFIX}/usr/include/phonon"
			-DQT_PHONON_LIBRARY_RELEASE="${EPREFIX}/usr/$(get_libdir)/libphonon.so"
		)
	fi

	configuration() {
		local mycmakeargs=(
			-DPYTHON_SUFFIX="-${EPYTHON}"
			"${mycmakeargs[@]}"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	local PYTHONDONTWRITEBYTECODE
	export PYTHONDONTWRITEBYTECODE

	VIRTUALX_COMMAND="cmake-utils_src_test" python_foreach_impl virtualmake
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
