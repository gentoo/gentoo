# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit versionator python-single-r1 gnome2-utils cmake-utils multilib

DESCRIPTION="Universal Software Radio Peripheral (USRP) Hardware Driver"
HOMEPAGE="https://kb.ettus.com"

image_version=uhd-images_00$(get_version_component_range 1).0$(get_version_component_range 2).00$(get_version_component_range 3).00$(get_version_component_range 4)-release
SRC_URI="https://github.com/EttusResearch/uhd/archive/v${PV}.tar.gz -> EttusResearch-UHD-${PV}.tar.gz \
	https://github.com/EttusResearch/uhd/releases/download/v${PV}/uhd-images_${PV}.tar.xz"
#https://github.com/EttusResearch/UHD-Mirror/tags
#http://files.ettus.com/binaries/images/

LICENSE="GPL-3"
SLOT="0/$(get_version_component_range 1).$(get_version_component_range 2)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="b100 b200 doc e300 examples mpmd octoclock n230 test usb usrp1 usrp2 +utils x300"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
			b100? ( usb )
			b200? ( usb )
			usrp1? ( usb )
			usrp2? ( usb )
			|| ( b100 b200 e300 mpmd n230 usrp1 usrp2 x300 )"

RDEPEND="${PYTHON_DEPS}
	e300? ( virtual/udev )
	usb? ( virtual/libusb:1 )
	dev-libs/boost:=
	sys-libs/ncurses:0[tinfo]
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-python/mako
	app-arch/unzip
	app-arch/gzip
"

PATCHES=( "${FILESDIR}/${PN}-3.10.3.0-tinfo.patch" )

S="${WORKDIR}/${P}/host"

src_unpack() {
	default
	mv "uhd-images_${PV}" images || die
}

src_prepare() {
	cmake-utils_src_prepare

	gnome2_environment_reset #534582

	#this may not be needed in 3.4.3 and above, please verify
	sed -i 's#SET(PKG_LIB_DIR ${PKG_DATA_DIR})#SET(PKG_LIB_DIR ${LIBRARY_DIR}/uhd)#g' CMakeLists.txt || die
}

src_configure() {
	mycmakeargs=(
		-DENABLE_LIBUHD=ON
		-DENABLE_C_API=ON
		-DENABLE_LIBERIO=OFF
		-DENABLE_MAN_PAGES=ON
		-DENABLE_GPSD=OFF
		-DENABLE_EXAMPLES="$(usex examples)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_USB="$(usex usb)"
		-DENABLE_UTILS="$(usex utils)"
		-DENABLE_MANUAL="$(usex doc)"
		-DENABLE_DOXYGEN="$(usex doc)"
		-DENABLE_B100="$(usex b100)"
		-DENABLE_B200="$(usex b200)"
		-DENABLE_E300="$(usex e300)"
		-DENABLE_USRP1="$(usex usrp1)"
		-DENABLE_USRP2="$(usex usrp2)"
		-DENABLE_X300="$(usex x300)"
		-DENABLE_N230="$(usex n230)"
		-DENABLE_MPMD="$(usex mpmd)"
		-DENABLE_OCTOCLOCK="$(usex octoclock)"
	)
	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install
	use utils && python_fix_shebang "${ED}"/usr/$(get_libdir)/${PN}/utils/
	if [ "${PV}" != "9999" ]; then
		rm -rf "${ED}/usr/bin/uhd_images_downloader"
		rm -rf "${ED}/usr/share/man/man1/uhd_images_downloader.1.gz"
	fi

	insinto /lib/udev/rules.d/
	doins "${S}/utils/uhd-usrp.rules"

	rm -rf "${WORKDIR}/images/winusb_driver"
	if ! use b100; then
		rm "${WORKDIR}"/images/usrp_b100* || die
	fi
	if ! use b200; then
		rm "${WORKDIR}"/images/usrp_b2[01]* || die
	fi
	if ! use e300; then
		rm "${WORKDIR}"/images/usrp_e3* || die
	fi
	if ! use mpmd; then
		rm "${WORKDIR}"/images/usrp_n310* || die
	fi
	if ! use n230; then
		rm "${WORKDIR}"/images/usrp_n230* || die
	fi
	if ! use octoclock; then
		rm "${WORKDIR}"/images/octoclock* || die
	fi
	if ! use usrp1; then
		rm "${WORKDIR}"/images/usrp1* || die
	fi
	if ! use usrp2; then
		rm "${WORKDIR}"/images/usrp2* || die
		rm "${WORKDIR}"/images/usrp_n2[01]* || die
		rm -r "${WORKDIR}"/images/bit || die
	fi
	if ! use x300; then
		rm "${WORKDIR}/"images/usrp_x3* || die
	fi
	insinto /usr/share/${PN}
	doins -r "${WORKDIR}/images"
}
