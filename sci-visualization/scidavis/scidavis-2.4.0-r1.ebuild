# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DEPEND="media-gfx/graphviz"

PYTHON_COMPAT=( python3_{7..9} )

inherit python-single-r1 docs qmake-utils xdg

DESCRIPTION="Application for Scientific Data Analysis and Visualization"
HOMEPAGE="http://scidavis.sourceforge.net/ https://github.com/SciDAVis/scidavis/"
SRC_URI="https://github.com/SciDAVis/scidavis/archive/refs/tags/${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="GPL-2+ ZLIB"
KEYWORDS="~amd64"
SLOT="0"

IUSE="assistant doc origin python test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# RESTRICT="!test? ( test )"
# Looks like we have an incompatible version of gtest in the tree, fails to
# compile with CONFIG+="test"
RESTRICT="test"

RDEPEND="
	dev-cpp/muParser
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sci-libs/gsl:=
	sys-libs/zlib[minizip]
	x11-libs/qwt:5
	x11-libs/qwtplot3d
	assistant? ( dev-qt/assistant )
	origin? ( sci-libs/liborigin )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/PyQt5[${PYTHON_USEDEP}]
			dev-python/PyQt5-sip[${PYTHON_USEDEP}]
			<dev-python/sip-5[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	test? (
		dev-libs/unittest++
		dev-cpp/gtest
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-build.patch"
)

src_prepare() {
	default

	# Fix small upstream typo
	sed -i -e 's/grabFramebuffer/grabFrameBuffer/g' libscidavis/src/Graph3D.cpp || die

	# Remove things which are packaged elsewhere
	rm -r 3rdparty/qwt5-qt5 3rdparty/qwtplot3d 3rdparty/liborigin || die

	# OF has been renamed in Gentoo https://bugs.gentoo.org/383179
	# Note this is *not* packaged in sys-libs/zlib[minizip] because
	# this file resides in the test directory in upstream zlib
	sed -i -r 's:\<(O[FN])\>:_Z_\1:g' 3rdparty/minigzip/minigzip.c || die

	# fix paths
	cat >> config.pri <<-EOF || die
		# install docs to ${PF} instead of ${PN}
		documentation.path = "\$\$INSTALLBASE/share/doc/${PF}"

		# install python files in Gentoo specific directories
		pythonconfig.path = "$(python_get_scriptdir)"
		pythonutils.path = "$(python_get_scriptdir)"

		# /usr/share/appdata is deprecated
		appdata.path = "\$\$INSTALLBASE/share/metainfo"
	EOF
}

src_configure() {
	INSTALLBASE="${EPREFIX}/usr" eqmake5 \
		$(usex assistant  " " " CONFIG+=noassistant ") \
		$(usex origin " CONFIG+=liborigin " " ") \
		$(usex python " CONFIG+=python " " ") \
		$(usex test " CONFIG+=test " " ")
}

src_compile() {
	default
	docs_compile
}

src_install () {
	emake INSTALL_ROOT="${ED}" install
	einstalldocs
	use python && python_optimize
}
