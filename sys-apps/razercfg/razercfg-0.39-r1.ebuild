# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit cmake-utils python-single-r1 systemd udev

DESCRIPTION="Utility for advanced configuration of Razer mice"
HOMEPAGE="https://bues.ch/cms/hacking/razercfg.html"
SRC_URI="https://bues.ch/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pm-utils +udev"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	virtual/libusb:1
	pm-utils? ( sys-power/pm-utils )
	udev? ( virtual/udev )
"
DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/libusb:1
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-unit-variables.patch" )

src_prepare() {
	cmake-utils_src_prepare

	sed -i CMakeLists.txt \
		-e '/udevadm control/{N;d}' \
		-e '/systemctl/{N;d}' \
		-e "s:/etc/pm/sleep.d:/usr/$(get_libdir)/pm-utils/sleep.d/:" \
		-e 's:50-razer:80razer:' \
		|| die

	sed -i librazer/CMakeLists.txt \
		-e '/ldconfig/{N;d}' \
		-e "s:DESTINATION lib:DESTINATION $(get_libdir):" \
		|| die

	sed -i razercfg.desktop.template \
		-e '/^Categories=/s/=.*$/=Qt;Settings/' \
		|| die
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON="${PYTHON}"
		-DSYSTEMD_UNIT_DIR="$(systemd_get_systemunitdir)"
		-DUDEV_DIR="$(get_udevdir)"
	)
	RAZERCFG_PKG_BUILD=1 cmake-utils_src_configure
}

src_install() {
	RAZERCFG_PKG_BUILD=1 cmake-utils_src_install

	newinitd "${FILESDIR}"/razerd.init.d-r2 razerd
	dodoc README.* HACKING.* razer.conf

	rm "${D%/}"/usr/bin/qrazercfg{,-applet} || die
	rm "${D%/}"/usr/share/icons/hicolor/scalable/apps/razercfg* || die
	rm "${D%/}"/usr/share/applications/razercfg.desktop || die

	if ! use pm-utils; then
		rm "${D%/}/usr/$(get_libdir)/pm-utils/sleep.d/80razer" || die
	fi
}

pkg_postinst() {
	if use udev ; then
		udevadm control --reload-rules
		udevadm trigger --subsystem-match=usb
	fi

	if [[ -e "${ROOT%/}"/usr/bin/pyrazer.pyc ]]; then
		eerror "A stale ${ROOT}usr/bin/pyrazer.pyc exists and will prevent"
		eerror "the Python frontends from working until removed manually."
	fi
}
