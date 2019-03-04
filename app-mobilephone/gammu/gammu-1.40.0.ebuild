# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="A tool to handle your cellular phone"
HOMEPAGE="https://wammu.eu/gammu/"
SRC_URI="https://dl.cihar.com/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth curl dbi debug irda mysql nls odbc postgres usb"

DEPEND="
	dev-libs/glib:2=
	virtual/libgudev:=
	bluetooth? ( net-wireless/bluez:= )
	curl? ( net-misc/curl:= )
	dbi? ( >=dev-db/libdbi-0.8.3:= )
	mysql? ( dev-db/mysql-connector-c:= )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:= )
	usb? ( virtual/libusb:1= )
"
BDEPEND="
	${DEPEND}
	irda? ( virtual/os-headers )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${DEPEND}
	dev-util/dialog
	virtual/libiconv
"
src_configure() {
	local mycmakeargs=(
		-DWITH_BLUETOOTH=$(usex bluetooth)
		-DWITH_CURL=$(usex curl)
		-DWITH_Gettext=$(usex nls)
		-DWITH_Iconv=$(usex nls)
		-DWITH_IRDA=$(usex irda)
		-DWITH_LibDBI=$(usex dbi)
		-DWITH_MySQL=$(usex mysql)
		-DWITH_ODBC=$(usex odbc)
		-DWITH_Postgres=$(usex postgres)
		-DWITH_USB=$(usex usb)
		-DBUILD_SHARED_LIBS=ON
		-DINSTALL_DOC_DIR="share/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_test() {
	addwrite "/run/lock/LCK..bar"
	LD_LIBRARY_PATH="${BUILD_DIR}/libgammu" cmake-utils_src_test -j1
}

src_install() {
	cmake-utils_src_install
	docompress -x /usr/share/doc/${PF}/examples/
}
