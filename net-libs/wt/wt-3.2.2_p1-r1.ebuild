# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/wt/wt-3.2.2_p1-r1.ebuild,v 1.8 2014/12/28 16:30:23 titanofold Exp $

EAPI="3"

inherit cmake-utils versionator eutils user

DESCRIPTION="C++ library for developing interactive web applications"
MY_P=${P/_/-}
HOMEPAGE="http://webtoolkit.eu/"
SRC_URI="mirror://sourceforge/witty/wt/3.2.2/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc +extjs fcgi graphicsmagick pdf postgres resources +server ssl +sqlite test zlib"

RDEPEND="
	>=dev-libs/boost-1.36
	graphicsmagick? ( media-gfx/graphicsmagick )
	pdf? ( media-libs/libharu )
	postgres? ( dev-db/postgresql )
	sqlite? ( dev-db/sqlite:3 )
	fcgi? (
		dev-libs/fcgi
		virtual/httpd-fastcgi
	)
	server? (
		ssl? ( dev-libs/openssl )
		zlib? ( sys-libs/zlib )
	)
"
DEPEND="${RDEPEND}"

DOCS="Changelog INSTALL"
S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use !server && use !fcgi; then
		ewarn "You have to select at least built-in server support or fcgi support."
		ewarn "Invalid use flag combination, enable at least one of: server, fcgi"
	fi

	if use test && use !sqlite; then
		ewarn "Tests need sqlite, disabling."
	fi

	enewgroup wt
	enewuser wt -1 -1 /var/lib/wt/home wt
}

src_prepare() {
	epatch "$FILESDIR/cmakelist.patch"

	# just to be sure
	rm -rf Wt/Dbo/backend/amalgamation

	# fix png linking
	if use pdf; then
		sed -e 's/-lpng12/-lpng/' \
			-i cmake/WtFindHaru.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	BOOST_PKG="$(best_version ">=dev-libs/boost-1.36.0")"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	BOOST_INC="/usr/include/boost-${BOOST_VER}"

	local mycmakeargs=(
		-DDESTDIR="${D}"
		-DLIB_INSTALL_DIR=$(get_libdir)
		$(cmake-utils_use test BUILD_TESTS)
		-DSHARED_LIBS=ON
		-DMULTI_THREADED=ON
		-DUSE_SYSTEM_SQLITE3=ON
		-DWEBUSER=wt
		-DWEBGROUP=wt
		$(cmake-utils_use extjs ENABLE_EXT)
		$(cmake-utils_use graphicsmagick ENABLE_GM)
		$(cmake-utils_use pdf ENABLE_HARU)
		$(cmake-utils_use postgres ENABLE_POSTGRES)
		$(cmake-utils_use sqlite ENABLE_SQLITE)
		$(cmake-utils_use fcgi CONNECTOR_FCGI)
		$(cmake-utils_use server CONNECTOR_HTTP)
		$(cmake-utils_use ssl WT_WITH_SSL)
		$(cmake-utils_use zlib HTTP_WITH_ZLIB)
		-DBUILD_EXAMPLES=OFF
		$(cmake-utils_use resources INSTALL_RESOURCES)
	)

	cmake-utils_src_configure
}

src_test() {
	# Tests need sqlite
	if use sqlite; then
		pushd "${CMAKE_BUILD_DIR}" > /dev/null
		./test/test || die
		popd > /dev/null
	fi
}

src_install() {

	dodir \
		/var/lib/wt \
		/var/lib/wt/home

	cmake-utils_src_install

	use doc && dohtml -A pdf,xhtml -r doc/*

}

pkg_postinst() {
	if use fcgi; then
		elog "You selected fcgi support. Please make sure that the web-server"
		elog "has fcgi support and access to the fcgi socket."
		elog "You can use spawn-fcgi to spawn the witty-processes and run them"
		elog "in a chroot environment."
	fi

	chown -R wt:wt \
		"${ROOT}"/var/lib/wt

	chmod 0750 \
		"${ROOT}"/var/lib/wt \
		"${ROOT}"/var/lib/wt/home

}
