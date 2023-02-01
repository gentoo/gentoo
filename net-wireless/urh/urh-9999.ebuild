# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1 virtualx

DESCRIPTION="Universal Radio Hacker: investigate wireless protocols like a boss"
HOMEPAGE="https://github.com/jopohl/urh"

if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jopohl/urh.git"
else
	SRC_URI="https://github.com/jopohl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="airspy audio bladerf hackrf limesdr plutosdr rtlsdr sdrplay uhd"

DEPEND="${PYTHON_DEPS}
		net-wireless/gnuradio[zeromq]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyzmq[${PYTHON_USEDEP}]
		dev-python/cython[${PYTHON_USEDEP}]
		airspy? ( net-wireless/airspy:= )
		audio? ( dev-python/pyaudio[${PYTHON_USEDEP}] )
		bladerf? ( net-wireless/bladerf:= )
		hackrf? ( net-libs/libhackrf:= )
		limesdr? ( net-wireless/limesuite:= )
		plutosdr? ( net-libs/libiio:= )
		rtlsdr? ( net-wireless/rtl-sdr:= )
		sdrplay? ( <net-wireless/sdrplay-3.0.0:= )
		uhd?    ( net-wireless/uhd:= )"
RDEPEND="${DEPEND}
		dev-python/PyQt5[${PYTHON_USEDEP},testlib]
		net-wireless/gr-osmosdr"

distutils_enable_tests pytest

python_configure_all() {
	DISTUTILS_ARGS=(
			$(use_with airspy)
			$(use_with bladerf)
			$(use_with hackrf)
			$(use_with limesdr)
			$(use_with plutosdr)
			$(use_with rtlsdr)
			$(use_with sdrplay)
			$(use_with uhd usrp)
			)
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	# Why are these disabled?
	# import errors AND hangs forever after 'tests/test_spectrogram.py::TestSpectrogram::test_cancel_filtering'
	# import errors	'tests/test_continuous_modulator.py::TestContinuousModulator::test_modulate_continuously'
	# import errors	'tests/test_send_recv_dialog_gui.py::TestSendRecvDialog::test_continuous_send_dialog'
	# import errors	'tests/test_spectrogram.py::TestSpectrogram::test_channel_separation_with_negative_frequency'
	local EPYTEST_DESELECT=(
		'tests/test_spectrogram.py::TestSpectrogram::test_cancel_filtering'
		'tests/test_continuous_modulator.py::TestContinuousModulator::test_modulate_continuously'
		'tests/test_send_recv_dialog_gui.py::TestSendRecvDialog::test_continuous_send_dialog'
		'tests/test_spectrogram.py::TestSpectrogram::test_channel_separation_with_negative_frequency'

	)
	cd "${T}" || die
	epytest -s --pyargs urh.cythonext "${S}/tests" || die
}
