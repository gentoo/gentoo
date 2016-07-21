# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="lightweight file synchronizer utility"
HOMEPAGE="http://csync.org/"
SRC_URI="https://open.cryptomilk.org/attachments/download/27/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc iconv samba +sftp test"

RDEPEND=">=dev-db/sqlite-3.4:3
	net-libs/neon[ssl]
	iconv? ( virtual/libiconv )
	samba? ( >=net-fs/samba-3.5 )
	sftp? ( >=net-libs/libssh-0.5 )
	!net-misc/ocsync"
DEPEND="${RDEPEND}
	app-text/asciidoc
	doc? ( app-doc/doxygen )
	test? ( dev-util/cmocka )"

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s/__FUNCTION__/__func__/" -i \
		src/csync_log.h tests/csync_tests/check_csync_log.c || die
	# proper docdir
	sed -e "s:/doc/${PN}:/doc/${PF}:" \
		-i doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		$(cmake-utils_use_with iconv ICONV)
		$(cmake-utils_use test UNIT_TESTING)
		$(cmake-utils_use_find_package doc Doxygen)
		$(cmake-utils_use_find_package samba Libsmbclient)
		$(cmake-utils_use_find_package sftp LibSSH)
	)
	cmake-utils_src_configure
}
