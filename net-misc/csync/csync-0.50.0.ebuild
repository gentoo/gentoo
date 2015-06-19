# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/csync/csync-0.50.0.ebuild,v 1.4 2014/12/24 05:15:50 jer Exp $

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
