# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

MY_P=${PN}${PV}

inherit qmake-utils python-single-r1 subversion

DESCRIPTION="A dynamic Python binding for the Qt framework"
HOMEPAGE="http://pythonqt.sourceforge.net/"
SRC_URI=""
ESVN_REPO_URI="https://pythonqt.svn.sourceforge.net/svnroot/pythonqt/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc +extensions webkit"

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
		webkit? ( dev-qt/qtwebkit:5 )
	)"
DEPEND="${RDEPEND}
	dev-qt/qtxml:5
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_P}"

REQUIRED_USE="webkit? ( extensions ) ${PYTHON_REQUIRED_USE}"

src_prepare() {
	default

	if ! use extensions ; then
		sed -i '/SUBDIRS/s/extensions//' PythonQt.pro || die "sed for extensions"
	fi
	if ! use webkit ; then
		# Remove webkit support if not used
		sed -i '/qtHaveModule(webkit):CONFIG += PythonQtWebKit/d' \
			extensions/PythonQt_QtAll/PythonQt_QtAll.pro \
			|| die "sed for webkit"
	fi

	# Unset python version to use python-config
	sed -i "/unix:PYTHON_VERSION=/s/2.7//" build/python.prf \
		|| die "sed for python version"
}

src_configure() {
	eqmake5 PREFIX="${ED%/}"/usr
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
