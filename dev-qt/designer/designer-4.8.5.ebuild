# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-build

DESCRIPTION="WYSIWYG tool for designing and building Qt-based GUIs"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

DESIGNER_PLUGINS="declarative phonon qt3support webkit"
IUSE="${DESIGNER_PLUGINS} kde"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[aqua=,debug=]
	~dev-qt/qtscript-${PV}[aqua=,debug=]
	declarative? ( ~dev-qt/qtdeclarative-${PV}[aqua=,debug=] )
	phonon? ( !kde? ( ~dev-qt/qtphonon-${PV}[aqua=,debug=] ) )
	qt3support? ( ~dev-qt/qt3support-${PV}[aqua=,debug=] )
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}"
PDEPEND="phonon? ( kde? ( media-libs/phonon[designer,qt4] ) )"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="tools/designer"
	QT4_EXTRACT_DIRECTORIES="
		include
		src
		tools"

	qt4-build_pkg_setup
}

src_prepare() {
	qt4-build_src_prepare

	local plugin
	for plugin in ${DESIGNER_PLUGINS}; do
		if ! use ${plugin} || ( [[ ${plugin} == phonon ]] && use kde ); then
			sed -i -e "/\<${plugin}\>/d" \
				tools/designer/src/plugins/plugins.pro || die
		fi
	done
}

src_configure() {
	myconf+="
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-svg -no-webkit -no-phonon -no-opengl"

	qt4-build_src_configure
}

src_install() {
	qt4-build_src_install

	# qt-creator
	# some qt-creator headers are located
	# under /usr/include/qt4/QtDesigner/private.
	# those headers are just includes of the headers
	# which are located under tools/designer/src/lib/*
	# So instead of installing both, we create the private folder
	# and drop tools/designer/src/lib/* headers in it.
	if use aqua && [[ ${CHOST##*-darwin} -ge 9 ]]; then
		insinto "${QTLIBDIR#${EPREFIX}}"/QtDesigner.framework/Headers/private/
	else
		insinto "${QTHEADERDIR#${EPREFIX}}"/QtDesigner/private/
	fi
	doins "${S}"/tools/designer/src/lib/shared/*
	doins "${S}"/tools/designer/src/lib/sdk/*

	doicon tools/designer/src/designer/images/designer.png
	make_desktop_entry designer Designer designer 'Qt;Development;GUIDesigner'
}
