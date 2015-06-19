# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ocsync/ocsync-0.90.4.ebuild,v 1.1 2014/02/24 13:55:54 voyageur Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A file synchronizer especially designed for you, the normal user"
HOMEPAGE="http://csync.org/"
SRC_URI="http://download.owncloud.com/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc iconv samba +sftp test"

RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/iniparser-3.1
	net-libs/neon[ssl]
	iconv? ( virtual/libiconv )
	samba? ( net-fs/samba )
	sftp? ( net-libs/libssh )
	!net-misc/csync
	!>=net-misc/owncloud-client-1.5.1
"
DEPEND="${DEPEND}
	app-text/asciidoc
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check dev-util/cmocka )
"

src_prepare() {
	cmake-utils_src_prepare

	# proper docdir
	sed -e "s:/doc/ocsync:/doc/${PF}:" \
		-i doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use test UNIT_TESTING)
		$(cmake-utils_use_find_package doc Doxygen)
		$(cmake-utils_use_find_package samba Libsmbclient)
		$(cmake-utils_use_find_package sftp LibSSH)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mv "${D}/usr/etc/ocsync" "${D}/etc/"
	rm -r "${D}/usr/etc/"
}
