# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
EGIT_REPO_URI="https://github.com/MeVisLab/pythonqt.git"

inherit git-r3 qmake-utils python-single-r1 virtualx

DESCRIPTION="A dynamic Python binding for the Qt framework"
HOMEPAGE="https://mevislab.github.io/pythonqt"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug doc examples +extensions test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	extensions? (
		dev-qt/designer:5
		dev-qt/qtdeclarative:5[widgets]
		dev-qt/qtmultimedia:5[widgets]
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5
		dev-qt/qtsvg:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5
	)"
DEPEND="${RDEPEND}
	dev-qt/qtxml:5
	test? ( dev-qt/qttest:5 )"
BDEPEND="app-arch/unzip
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	default

	if ! use examples ; then
		sed -i '/SUBDIRS/s/examples//' PythonQt.pro || die "sed for examples"
	fi
	if ! use extensions ; then
		sed -i '/SUBDIRS/s/extensions//' PythonQt.pro || die "sed for extensions"
	fi
	if ! use test ; then
		sed -i '/SUBDIRS/s/tests//' PythonQt.pro || die "sed for test"
	fi

	# Remove webkit support if not used
	sed -i '/qtHaveModule(webkit):CONFIG += PythonQtWebKit/d' \
		extensions/PythonQt_QtAll/PythonQt_QtAll.pro \
		|| die "sed for webkit"

	# Unset python version to use python-config
	sed -i "/unix:PYTHON_VERSION=/s/2.7//" build/python.prf \
		|| die "sed for python version"
}

src_configure() {
	eqmake5 CONFIG+="$(usex debug debug release '' '')" PREFIX="${ED}"/usr
}

src_test() {
	LD_PRELOAD="${S}"/lib/libPythonQt-Qt5-Python"$(usex debug _d '' '' '')".so.3 \
		virtx ./lib/PythonQtTest"$(usex debug _d '' '' '')"
}

src_install() {
	einstalldocs

	# Includes
	insinto /usr/include/PythonQt
	doins -r src/*.h
	insinto /usr/include/PythonQt/gui
	doins -r src/gui/*.h

	if use extensions ; then
		insinto /usr/include/PythonQt/extensions/PythonQt_QtAll
		doins -r extensions/PythonQt_QtAll/*.h
	fi

	# Libraries
	dolib.so lib/libPythonQt*
}
