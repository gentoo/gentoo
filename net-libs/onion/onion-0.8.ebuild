# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/davidmoreno/onion"
fi

inherit ${SCM} cmake-utils

DESCRIPTION="C library to create simple HTTP servers and Web Applications"
HOMEPAGE="http://www.coralbits.com/libonion/ https://github.com/davidmoreno/onion"

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/davidmoreno/onion/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="|| ( GPL-2+ Apache-2.0 ) AGPL-3"
SLOT="0"
IUSE="
	gnutls pam png jpeg xml systemd sqlite boehm-gc
	test examples cxx -libev -libevent
	redis
"

RDEPEND="
	gnutls? ( net-libs/gnutls dev-libs/libgcrypt:0= )
	pam? ( virtual/pam )
	png? ( media-libs/libpng:0= x11-libs/cairo )
	jpeg? ( virtual/jpeg:0 )
	xml? ( dev-libs/libxml2:2 sys-libs/zlib )
	systemd? ( sys-apps/systemd )
	sqlite? ( dev-db/sqlite:3 )
	boehm-gc? ( dev-libs/boehm-gc )
	libev? ( dev-libs/libev )
	!libev? ( libevent? ( dev-libs/libevent ) )
	redis? ( dev-libs/hiredis )
"
DEPEND="${RDEPEND}
	test? ( net-misc/curl )
"
REQUIRED_USE="test? ( examples )"

src_configure() {
	use test || echo '' > tests/CMakeLists.txt
	local mycmakeargs=(
		"-DONION_USE_SSL=$(usex gnutls)"
		"-DONION_USE_PAM=$(usex pam)"
		"-DONION_USE_PNG=$(usex png)"
		"-DONION_USE_JPEG=$(usex jpeg)"
		"-DONION_USE_XML2=$(usex xml)"
		"-DONION_USE_SYSTEMD=$(usex systemd)"
		"-DONION_USE_SQLITE3=$(usex sqlite)"
		"-DONION_USE_GC=$(usex boehm-gc)"
		"-DONION_USE_TESTS=$(usex test)"
		"-DONION_EXAMPLES=$(usex examples)"
		"-DONION_USE_BINDINGS_CPP=$(usex cxx)"
		"-DONION_USE_REDIS=$(usex redis)"
		"-DONION_POLLER=$(usex libev libev "$(usex libevent libevent default)")"
	)
	cmake-utils_src_configure
}
