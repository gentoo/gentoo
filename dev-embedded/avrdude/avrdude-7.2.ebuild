# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="AVR Downloader/UploaDEr"
HOMEPAGE="https://avrdudes.github.io/avrdude https://github.com/avrdudes/avrdude"
SRC_URI="https://github.com/avrdudes/avrdude/archive/refs/tags/v${PV}.tar.gz -> avrdude-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/1" # SOVERSION in src/CMakeLists.txt
KEYWORDS="amd64 arm ppc ppc64 x86"
IUSE="ftdi readline"

RDEPEND="
	dev-libs/hidapi
	virtual/libelf:=
	virtual/libusb:0
	virtual/libusb:1
	ftdi? ( dev-embedded/libftdi:1 )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
"

src_prepare() {
	cmake_src_prepare

	# CMAKE_INSTALL_LIBDIR is not respected. Fixed in the next release.
	sed -i "s@DESTINATION lib@DESTINATION $(get_libdir)@g" \
		src/CMakeLists.txt || die

	# For some reason 'TYPE SYSCONF' and 'CMAKE_INSTALL_SYSCONFDIR'
	# prepends '/usr' so the config ends up getting installed as
	# '/usr/etc/avrdude.conf' which is not correct.
	sed -i 's@TYPE SYSCONF@DESTINATION ${CMAKE_INSTALL_FULL_SYSCONFDIR}@' \
		src/CMakeLists.txt || die
}

src_configure() {
	# Optional libraries like libftdi aren't gated behind options and
	# find_package calls, but find_library is called directly
	# instead.
	#
	# Set the cache variable to an empty string if we do not want a
	# library to be automatically detected.
	local mycmakeargs=(
		-DBUILD_DOC=OFF # This currently does nothing...
		-DBUILD_SHARED_LIBS=ON
		-DDEBUG_CMAKE=ON
		-DHAVE_LIBGPIOD='' # Bug #921301
		-DHAVE_LIBFTDI=''
		-DHAVE_LINUXGPIO=ON # Seems like there is no reason to have this off.
		-DHAVE_LINUXSPI=ON # Ditto.
		-DHAVE_PARPORT=ON
	)
	use ftdi || mycmakeargs+=( -DHAVE_LIBFTDI1='' )
	use readline || mycmakeargs+=( -DHAVE_LIBREADLINE='' )
	cmake_src_configure
}
