# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )

inherit cmake gnome2-utils python-single-r1 udev

DESCRIPTION="Universal Software Radio Peripheral (USRP) Hardware Driver"
HOMEPAGE="https://kb.ettus.com"

SRC_URI="https://github.com/EttusResearch/uhd/archive/v${PV}.tar.gz -> EttusResearch-UHD-${PV}.tar.gz \
	https://github.com/EttusResearch/uhd/releases/download/v${PV}/uhd-images_${PV}.tar.xz"
#https://github.com/EttusResearch/UHD-Mirror/tags
#http://files.ettus.com/binaries/images/

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1-3)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+b100 +b200 doc e300 examples +mpmd octoclock +n230 test +usb +usrp1 +usrp2 +utils +x300"
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
	sys-libs/ncurses:0=
	$(python_gen_cond_dep '
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
#zip and gzip are directly used by the build system
BDEPEND="
	doc? ( app-doc/doxygen )
	$(python_gen_cond_dep '
	dev-python/mako[${PYTHON_USEDEP}]
	')
	app-arch/unzip
	app-arch/gzip
"

PATCHES=(
	"${FILESDIR}/${PN}-4.1.0.5-hidden-visibility-tests.patch"
)

S="${WORKDIR}/${P}/host"

src_unpack() {
	default
	mv "uhd-images_${PV}" images || die
}

src_prepare() {
	cmake_src_prepare

	gnome2_environment_reset #534582
}

src_configure() {
	#https://gitlab.kitware.com/cmake/cmake/-/issues/23236
	#https://github.com/EttusResearch/uhd/pull/560
	local mycmakeargs=(
		-DCURSES_NEED_NCURSES=ON
		-DENABLE_LIBUHD=ON
		-DENABLE_C_API=ON
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MAN_PAGE_COMPRESSION=OFF
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
		-DENABLE_MPMD="$(usex mpmd)"
		-DENABLE_OCTOCLOCK="$(usex octoclock)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPKG_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
	if use utils; then
		python_fix_shebang "${ED}"/usr/$(get_libdir)/${PN}/utils/
		if [[ "${PV}" != "9999" ]]; then
			rm -r "${ED}/usr/bin/uhd_images_downloader" || die
			rm -r "${ED}/usr/share/man/man1/uhd_images_downloader.1" || die
		fi
	fi

	udev_dorules "${S}/utils/uhd-usrp.rules"

	rm -r "${WORKDIR}/images/winusb_driver" || die
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
