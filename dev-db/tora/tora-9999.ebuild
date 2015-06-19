# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/tora/tora-9999.ebuild,v 1.7 2015/04/26 18:00:30 zmedico Exp $

EAPI=5

inherit cmake-utils eutils

if [[ ${PV} == 9999 ]]; then
	ESVN_REPO_URI="https://tora.svn.sourceforge.net/svnroot/tora/trunk/tora"
	inherit subversion
	SRC_URI=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi

DESCRIPTION="TOra - Toolkit For Oracle"
HOMEPAGE="http://torasql.com/"
IUSE="debug mysql oracle oci8-instant-client postgres"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""

DEPEND="
	virtual/pkgconfig
	dev-libs/ferrisloki
	x11-libs/qscintilla
	dev-qt/qtgui:4
	dev-qt/qtsql:4[mysql?,postgres?]
	dev-qt/qtxmlpatterns:4
	oci8-instant-client? ( dev-db/oracle-instantclient-basic )
	postgres? ( dev-db/postgresql )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ( use oracle || use oci8-instant-client ) && [ -z "$ORACLE_HOME" ] ; then
		eerror "ORACLE_HOME variable is not set."
		eerror
		eerror "You must install Oracle >= 8i client for Linux in"
		eerror "order to compile TOra with Oracle support."
		eerror
		eerror "Otherwise specify -oracle in your USE variable."
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
	# 'svn info' needs .svn subdirectory
	[[ ${PV} != 9999 ]] || cp -a "${ESVN_WC_PATH}"/.svn .svn || die
	# bug 547520
	grep -rlZ '$$ORIGIN' . | xargs -0 sed -i 's|:$$ORIGIN[^:"]*||' || \
		die 'Removal of $$ORIGIN failed'
}

src_configure() {
	local mycmakeargs=()
	if use oracle || use oci8-instant-client ; then
		mycmakeargs=(-DENABLE_ORACLE=ON)
	else
		mycmakeargs=(-DENABLE_ORACLE=OFF)
	fi
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
	doicon src/icons/${PN}.xpm
	domenu src/${PN}.desktop
}
