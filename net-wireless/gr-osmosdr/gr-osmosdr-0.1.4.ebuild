# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/gr-osmosdr/gr-osmosdr-0.1.4.ebuild,v 1.1 2014/11/05 05:05:10 zerochaos Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="GNU Radio source block for OsmoSDR and rtlsdr and hackrf"
HOMEPAGE="http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
	KEYWORDS=""
else
	#git clone git://git.osmocom.org/gr-osmosdr.git
	#cd gr-osmosdr
	#git archive --format=tar --prefix=gr-osmosdr-${PV}/ v${PV} | xz > ../gr-osmosdr-${PV}.tar.xz
	SRC_URI="http://cgit.osmocom.org/gr-osmosdr/snapshot/gr-osmosdr-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${PV}"
IUSE="bladerf fcd hackrf iqbalance mirisdr python rtlsdr uhd"

RDEPEND="${PYTHON_DEPS}
	dev-libs/boost:=
	>=net-wireless/gnuradio-3.7_rc:0=[fcd?,${PYTHON_USEDEP}]
	bladerf? ( net-wireless/bladerf:= )
	hackrf? ( net-libs/libhackrf:= )
	iqbalance? ( net-wireless/gr-iqbal:=[${PYTHON_USEDEP}] )
	mirisdr? ( net-libs/libmirisdr:= )
	rtlsdr? ( >=net-wireless/rtl-sdr-0.5.3:= )
	uhd? ( net-wireless/uhd:=[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/cheetah"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEFAULT=OFF
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DENABLE_FILE=ON
		$(cmake-utils_use_enable bladerf)
		$(cmake-utils_use_enable fcd)
		$(cmake-utils_use_enable hackrf)
		$(cmake-utils_use_enable iqbalance)
		$(cmake-utils_use_enable mirisdr MIRI)
		$(cmake-utils_use_enable python)
		$(cmake-utils_use_enable rtlsdr RTL)
		$(cmake-utils_use_enable rtlsdr RTL_TCP)
		$(cmake-utils_use_enable uhd)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"/usr/bin
}
