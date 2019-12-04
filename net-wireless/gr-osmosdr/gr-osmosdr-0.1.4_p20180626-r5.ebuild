# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="GNU Radio source block for OsmoSDR and rtlsdr and hackrf"
HOMEPAGE="http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
else
	#SRC_URI="http://cgit.osmocom.org/gr-osmosdr/snapshot/gr-osmosdr-${PV}.tar.xz"
	#git clone git://git.osmocom.org/gr-osmosdr.git
	#cd gr-osmosdr
	#git archive --format=tar --prefix=gr-osmosdr-${PV}/ v${PV} | xz > ../gr-osmosdr-${PV}.tar.xz
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/gr-osmosdr-${PV}.tar.xz"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="bladerf fcd hackrf iio iqbalance mirisdr python rtlsdr sdrplay soapy uhd"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=
	>=net-wireless/gnuradio-3.7_rc:0=[fcd?,${PYTHON_USEDEP}]
	bladerf? ( >=net-wireless/bladerf-2018.08_rc1:= )
	hackrf? ( net-libs/libhackrf:= )
	iio? ( net-wireless/gr-iio )
	iqbalance? ( net-wireless/gr-iqbal:=[${PYTHON_USEDEP}] )
	mirisdr? ( net-libs/libmirisdr:= )
	rtlsdr? ( >=net-wireless/rtl-sdr-0.5.4:= )
	sdrplay? ( net-wireless/sdrplay )
	soapy? ( net-wireless/soapysdr:= )
	uhd? ( net-wireless/uhd:=[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/cheetah"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	eapply "${FILESDIR}/csete-iio.patch"
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DENABLE_FILE=ON
		-DENABLE_BLADERF="$(usex bladerf)"
		-DENABLE_FCD="$(usex fcd)"
		-DENABLE_HACKRF="$(usex hackrf)"
		-DENABLE_IIO="$(usex iio)"
		-DENABLE_IQBALANCE="$(usex iqbalance)"
		-DENABLE_MIRI="$(usex mirisdr)"
		-DENABLE_PYTHON="$(usex python)"
		-DENABLE_RTL="$(usex rtlsdr)"
		-DENABLE_RTL_TCP="$(usex rtlsdr)"
		-DENABLE_SOAPY="$(usex soapy)"
		-DENABLE_UHD="$(usex uhd)"
		-DENABLE_SDRPLAY="$(usex sdrplay)"
		-DENABLE_NONFREE="$(usex sdrplay)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use python; then
		python_fix_shebang "${ED}"/usr/bin
	fi
}
