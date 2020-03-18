# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="lightweight file synchronizer utility"
HOMEPAGE="https://www.csync.org/"
SRC_URI="https://open.cryptomilk.org/attachments/download/27/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc iconv samba +sftp test"
RESTRICT="!test? ( test )"

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

PATCHES=( "${FILESDIR}"/${P}-gcc_5_and_8.patch )
src_prepare() {
	cmake-utils_src_prepare

	# proper docdir
	sed -e "s:/doc/${PN}:/doc/${PF}:" \
		-i doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc
		-DWITH_ICONV="$(usex iconv)"
		-DUNIT_TESTING="$(usex test)"
		$(cmake-utils_use_find_package doc Doxygen)
		$(cmake-utils_use_find_package samba SMBClient)
		$(cmake-utils_use_find_package sftp LibSSH)
	)
	cmake-utils_src_configure
}
