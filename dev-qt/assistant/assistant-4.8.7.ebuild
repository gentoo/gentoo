# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/assistant/assistant-4.8.7.ebuild,v 1.1 2015/05/26 18:16:12 pesa Exp $

EAPI=5
inherit eutils qt4-build-multilib

DESCRIPTION="Tool for viewing on-line documentation in Qt help file format"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
fi

IUSE="webkit"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qthelp-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtsql-${PV}[aqua=,debug=,sqlite,${MULTILIB_USEDEP}]
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.8.2+gcc-4.7.patch"
)

QT4_TARGET_DIRECTORIES="tools/assistant/tools/assistant"

src_prepare() {
	# bug 401173
	use webkit || PATCHES+=("${FILESDIR}/disable-webkit.patch")

	qt4-build-multilib_src_prepare
}

multilib_src_configure() {
	local myconf=(
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-multimedia -no-opengl -no-phonon -no-svg -no-xmlpatterns
		$(qt_use webkit)
	)
	qt4_multilib_src_configure
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	doicon tools/assistant/tools/assistant/images/assistant.png
	make_desktop_entry assistant Assistant assistant 'Qt;Development;Documentation'
}
