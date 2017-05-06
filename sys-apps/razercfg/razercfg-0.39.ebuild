# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_4 python3_5 python3_6 )

inherit cmake-utils multilib udev python-single-r1

DESCRIPTION="Utility for advanced configuration of Razer mice"

HOMEPAGE="http://bues.ch/cms/hacking/razercfg.html"
SRC_URI="http://bues.ch/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pm-utils qt4 systemd +udev"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	qt4? ( >=dev-python/pyside-1.2.1[${PYTHON_USEDEP}] )
	systemd? ( sys-apps/systemd )
	udev? ( virtual/udev )
	pm-utils? ( sys-power/pm-utils )
	virtual/libusb:1"
DEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/libusb:1"

src_prepare() {
	default

	sed -i CMakeLists.txt \
		-e '/udevadm control/{N;d}' \
		-e '/systemctl/{N;d}' \
		-e "s:/etc/pm/sleep.d:/usr/$(get_libdir)/pm-utils/sleep.d/:" \
		-e 's:50-razer:80razer:' \
		|| die "sed failed"

	sed -i librazer/CMakeLists.txt \
		-e '/ldconfig/{N;d}' \
		-e "s:DESTINATION lib:DESTINATION $(get_libdir):" \
		|| die "sed failed"

	sed -i razercfg.desktop.template \
		-e '/^Categories=/s/=.*$/=Qt;Settings/' \
		|| die 'sed failed'
}

src_configure() {
	mycmakeargs=( -DPYTHON="${PYTHON}" )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}"/razerd.init.d-r2 razerd
	dodoc README.* HACKING.* razer.conf

	if ! use qt4; then
		rm "${D}"/usr/bin/qrazercfg{,-applet} || die
		rm "${D}"/usr/share/icons/hicolor/scalable/apps/razercfg* || die
		rm "${D}"/usr/share/applications/razercfg.desktop || die
	fi

	if ! use pm-utils; then
		rm "${D}/usr/$(get_libdir)/pm-utils/sleep.d/80razer" || die
	fi
}

pkg_postinst() {
	if use udev ; then
		udevadm control --reload-rules
		udevadm trigger --subsystem-match=usb
	fi

	if [[ -e "${ROOT}"usr/bin/pyrazer.pyc ]]; then
		eerror "A stale ${ROOT}usr/bin/pyrazer.pyc exists and will prevent"
		eerror "the Python frontends from working until removed manually."
	fi
}
