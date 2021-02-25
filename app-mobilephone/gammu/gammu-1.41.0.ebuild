# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A tool to handle your cellular phone"
HOMEPAGE="https://wammu.eu/gammu/"
SRC_URI="https://dl.cihar.com/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="bluetooth curl dbi debug irda mysql nls odbc postgres usb"

DEPEND="
	dev-libs/glib:2=
	dev-libs/libgudev:=
	virtual/libiconv
	bluetooth? ( net-wireless/bluez:= )
	curl? ( net-misc/curl:= )
	dbi? ( >=dev-db/libdbi-0.8.3:= )
	irda? ( virtual/os-headers )
	mysql? ( dev-db/mysql-connector-c:= )
	nls? ( sys-devel/gettext )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:= )
	usb? ( virtual/libusb:1= )
"

RDEPEND="
	${DEPEND}
	dev-util/dialog
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
		-DINSTALL_DOC_DIR="share/doc/${PF}"
	)
	cmake_src_configure
}

src_test() {
	addwrite "/run/lock/LCK..bar"
	LD_LIBRARY_PATH="${BUILD_DIR}/libgammu" cmake_src_test -j1
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/doc/${PF}/examples/
}
