# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit cmake python-single-r1

DESCRIPTION="AVR Downloader/UploaDEr"
HOMEPAGE="https://avrdudes.github.io/avrdude https://github.com/avrdudes/avrdude"
SRC_URI="https://github.com/avrdudes/avrdude/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/4" # SOVERSION in src/CMakeLists.txt
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="ftdi gpiod python readline"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/hidapi
	virtual/libelf:=
	virtual/libusb:0
	virtual/libusb:1
	ftdi? ( dev-embedded/libftdi:1 )
	!ppc? ( !ppc64? (
		gpiod? ( dev-libs/libgpiod:= )
		dev-libs/libserialport
	) )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
	python? ( >=dev-lang/swig-4.0 )
"

PATCHES=( "${FILESDIR}/no-automatic-libgpiod.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

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
		-DBUILD_SHARED_LIBS=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=TRUE
		-DDEBUG_CMAKE=ON
		-DFORCE_DISABLE_PYTHON_SUPPORT=$(usex python FALSE TRUE)
		-DHAVE_LIBFTDI=''
		-DHAVE_LIBGPIOD=$(usex gpiod)
		-DHAVE_LINUXGPIO=ON # Seems like there is no reason to have this off.
		-DHAVE_LINUXSPI=ON # Ditto.
		-DHAVE_PARPORT=ON
	)
	use ftdi || mycmakeargs+=( -DHAVE_LIBFTDI1='' )
	use readline || mycmakeargs+=( -DHAVE_LIBREADLINE='' )
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use python && python_optimize
}
