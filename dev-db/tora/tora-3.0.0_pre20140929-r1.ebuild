# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils eutils

if [[ ${PV} == 9999 ]]; then
	ESVN_REPO_URI="https://tora.svn.sourceforge.net/svnroot/tora/trunk/tora"
	inherit subversion
	SRC_URI=""
else
	SRC_URI="https://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.xz"
fi

DESCRIPTION="TOra - Toolkit For Oracle"
HOMEPAGE="http://torasql.com/"
IUSE="debug mysql postgres"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/ferrisloki
	x11-libs/qscintilla
	dev-qt/qtgui:4
	dev-qt/qtsql:4[mysql?,postgres?]
	dev-qt/qtxmlpatterns:4
	=dev-db/oracle-instantclient-basic-11*
	postgres? ( dev-db/postgresql )
"

DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"

pkg_setup() {
	if [ -z "$ORACLE_HOME" ] ; then
		eerror "ORACLE_HOME variable is not set."
		eerror
		eerror "You must install Oracle >= 8i client for Linux in"
		eerror "order to compile TOra with Oracle support."
		eerror
		eerror "You can download the Oracle software from"
		eerror "http://otn.oracle.com/software/content.html"
		die
	fi
}

src_prepare() {
	sed -i \
		-e "/COPYING/ d" \
		CMakeLists.txt || die "Removal of COPYING file failed"
	# bug 547520
	grep -rlZ '$$ORIGIN' . | xargs -0 sed -i 's|:$$ORIGIN[^:"]*||' || \
		die 'Removal of $$ORIGIN failed'
}

src_configure() {
	local mycmakeargs=()
	mycmakeargs=(-DENABLE_ORACLE=ON)
	mycmakeargs+=(
		-DWANT_RPM=OFF
		-DWANT_BUNDLE=OFF
		-DWANT_BUNDLE_STANDALONE=OFF
		-DWANT_INTERNAL_QSCINTILLA=OFF
		-DWANT_INTERNAL_LOKI=OFF
		-DLOKI_LIBRARY="$(pkg-config --variable=libdir ferrisloki)/libferrisloki.so"
		-DLOKI_INCLUDE_DIR="$(pkg-config --variable=includedir ferrisloki)/FerrisLoki"
		$(cmake-utils_use_enable postgres PGSQL)
		$(cmake-utils_use_want debug)
		# path variables
		-DTORA_DOC_DIR=share/doc/${PF}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	#
	doicon src/icons/${PN}.xpm || die
	domenu src/${PN}.desktop || die
}
