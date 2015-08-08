# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-build

DESCRIPTION="Tool for viewing on-line documentation in Qt help file format"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

IUSE="webkit"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=]
	~dev-qt/qtgui-${PV}[aqua=,debug=]
	~dev-qt/qthelp-${PV}[aqua=,debug=]
	~dev-qt/qtsql-${PV}[aqua=,debug=,sqlite]
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.8.2+gcc-4.7.patch"
)

pkg_setup() {
	QT4_TARGET_DIRECTORIES="tools/assistant/tools/assistant"
	QT4_EXTRACT_DIRECTORIES="
		include
		src
		tools"

	qt4-build_pkg_setup
}

src_prepare() {
	# bug 401173
	use webkit || PATCHES+=("${FILESDIR}/disable-webkit.patch")

	qt4-build_src_prepare
}

src_configure() {
	myconf+="
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-multimedia -no-opengl -no-phonon -no-svg -no-xmlpatterns
		$(qt_use webkit)"

	qt4-build_src_configure
}

src_install() {
	qt4-build_src_install

	doicon tools/assistant/tools/assistant/images/assistant.png
	make_desktop_entry assistant Assistant assistant 'Qt;Development;Documentation'
}
